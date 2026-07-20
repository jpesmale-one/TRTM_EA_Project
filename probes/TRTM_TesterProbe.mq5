//+------------------------------------------------------------------+
//|                                          TRev_TradeManager.mq5   |
//|  TRTM - TRev Trade Manager                                       |
//|  Stage 5: GUI panel + dashboard (entry/close buttons, Option-B   |
//|  next-trigger row, warning row) + b9 observability ride-alongs   |
//|                                                                  |
//|  STAGE STATUS:                                                   |
//|   [X] Stage 1: Skeleton + StateManager + logging                 |
//|   [X] Stage 2: AdoptionEngine                                    |
//|   [X] Stage 3: ExitEngine core (TP / avg TP / anchored SL)       |
//|   [X] Stage 4: RecoveryEngine                                    |
//|   [>] Stage 5: GUI panel + dashboard                             |
//|   [ ] Stage 6: BE + Trailing (with runtime override buttons)     |
//|   [ ] Stage 7: SafetyLayer + restart-recovery hardening          |
//+------------------------------------------------------------------+
#property copyright "Jeff"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>

#define TRTM_BUILD  "Stage8-b28-TPROBE3"  // internal build tag, bump per delivery

//+------------------------------------------------------------------+
//| ENUMS                                                            |
//+------------------------------------------------------------------+
enum ENUM_MM_MODE
  {
   MM_FIXED_LOT     = 0,  // Entry Lot Size (fixed)
   MM_BALANCE_RATIO = 1,  // Balance Ratio Mode
   MM_PERCENT_RISK  = 2   // Percentage Risk Mode (requires SL > 0)
  };

enum ENUM_RECOVERY_MULT_MODE
  {
   RM_INCREMENTAL          = 0,  // Incremental
   RM_FIXED                = 1,  // Fixed
   RM_MARTINGALE           = 2,  // Martingale
   RM_DEFERRED_INCREMENTAL = 3,  // Deferred Incremental
   RM_DEFERRED_MARTINGALE  = 4,  // Deferred Martingale
   RM_MANUAL               = 5   // Manual Multiplier (comma separated)
  };

enum ENUM_TRAIL_MODE
  {
   TRAIL_FIXED_DISTANCE = 0,  // Fixed Distance
   TRAIL_PREV_CANDLE    = 1   // Previous Candle High/Low
  };

//+------------------------------------------------------------------+
//| INPUTS                                                           |
//| NOTE (Stage 1): all inputs are declared so the dialog layout is  |
//| locked now. Inputs owned by later stages are INERT until that    |
//| stage lands. Ownership is tagged per section.                    |
//+------------------------------------------------------------------+
input group "=== Money Management - L1 Entry (Stage 5) ==="
input ENUM_MM_MODE InpMoneyMode        = MM_FIXED_LOT; // Money Management Mode
input double       InpEntryLotSize     = 0.01;         // Entry Lot Size (MM_FIXED_LOT)
input double       InpBalancePerLot    = 1000;         // Balance per 0.01 Lot (MM_BALANCE_RATIO)
input double       InpRiskPercent      = 1.0;          // Risk % per Trade (MM_PERCENT_RISK)
input long         InpMagicNumber      = 0;            // Magic Number (0 = derive from symbol)

input group "=== Adoption (Stage 2) ==="
input bool InpManageMobileTrades = false; // Manage Mobile Trades (adopt untagged manual trades - see README)

input group "=== Recovery Trade Management (Stage 4) ==="
input bool                     InpEnableRecovery    = true;          // Enable Recovery Trades
input ENUM_RECOVERY_MULT_MODE  InpRecoveryMultMode  = RM_INCREMENTAL;// Recovery Multiplier Mode
input double                   InpIncrementStep     = 0.01;          // Incremental: step per level
input double                   InpFixedRecoveryLot  = 0.01;          // Fixed: lot for all levels
input double                   InpMartingaleMult    = 2.0;           // Martingale: multiplier
input int                      InpDeferredStep      = 2;             // Deferred: levels per step
input string                   InpManualMultipliers = "1,2,5,8,12";  // Manual: multipliers (CSV)
input int                      InpRecoveryIntervalPts = 300;         // Recovery Interval (points)
input bool                     InpBarCloseEntry     = true;          // Bar Close Recovery Entry
input ENUM_TIMEFRAMES          InpRecoveryTF        = PERIOD_M15;    // Recovery Entry Timeframe
input int                      InpMaxRecoveryTrades = 0;             // Max Recovery Trades (0 = unlimited)

input group "=== Exit Rules (Stage 3 / Stage 6) ==="
input int             InpInitialTPPts   = 300;   // Initial Trade Profit (points, 0 = off)
input int             InpAvgTPPts       = 200;   // Recovery Avg TP Target (points, 0 = off)
input int             InpStopLossPts    = 0;     // Stop Loss (points, 0 = off, anchored to lowest level)
input bool            InpEnableBE       = false; // Enable Break-Even SL (default; button overrides per sequence)
input int             InpBETriggerPts   = 100;   // BE Trigger (points profit from avg entry)
input int             InpBEOffsetPts    = 30;    // BE Offset (points from avg, profit side)
input bool            InpBEAutoAdjust   = true;  // Auto Adjust BE for swaps/fees
input bool            InpEnableTrailing = false; // Enable Trailing Stop (default; button overrides per sequence)
input int             InpTrailDistPts   = 100;   // Trailing Distance (points)
input ENUM_TRAIL_MODE InpTrailMode      = TRAIL_FIXED_DISTANCE; // Trail Stop Mode
input int             InpMinTrailStepPts= 10;    // Min Step to Update SL (points)
input bool            InpTrailBarClose  = false; // Trail on Bar Close Only
input ENUM_TIMEFRAMES InpTrailTF        = PERIOD_M15; // Trailing Timeframe

input group "=== Filters & Safety (Stage 7) ==="
input bool   InpSpreadFilter   = true;  // Spread Filter (recovery entries only)
input int    InpMaxSpreadPts   = 80;    // Max Spread (points)
input bool   InpDeviationFilter= true;  // Max Deviation Filter (recovery entries only)
input int    InpMaxDeviationPts= 15;    // Max Deviation (points)
input bool   InpEnableDDClose  = false; // Enable Drawdown Auto Close
input double InpMaxDDPercent   = 0.0;   // Max DD in % of Balance (0 = off)
input double InpMaxDDUSD       = 0.0;   // Max DD in USD (0 = off)

input group "=== System (Stage 1) ==="
input bool InpLogToFile   = true;  // Write logs to daily file
input bool InpRunSelfTest = true;  // Run state persistence self-test on init
input int  InpLogRetentionDays = 14; // Delete own logs older than N days (0 = keep forever)

//+------------------------------------------------------------------+
//| CONSTANTS                                                        |
//+------------------------------------------------------------------+
#define TRTM_TAG              "TRTM"
#define TRTM_DIR_BASE         "TRTM\\"          // under MQL5\Files\
#define TRTM_STATE_SCHEMA     4                 // v4: +baseLot                 // bump on breaking state format change
#define TRTM_MAX_LEVELS       64                // hard array bound, not a trading limit

// Log levels
#define LOG_INFO   0
#define LOG_WARN   1
#define LOG_ERROR  2

// Stage 7 (b22): instance-lock heartbeat. The owner stamps _HB every
// LOCK_HB_REFRESH_SEC from OnTimer; an acquirer treats the lock as DEAD
// when the stamp is older than LOCK_HB_STALE_SEC even if the owner chart
// still exists (chart-alive/EA-dead hole, evidenced Stage 7 kill tests).
// 6x margin: a busy-but-alive EA can never be usurped (matrix B4).
// Clock: TimeLocal() on both ends - globals are per-terminal, and the
// terminal clock keeps running on weekends (matrix B3), unlike TimeCurrent.
#define LOCK_HB_REFRESH_SEC  10
#define LOCK_HB_STALE_SEC    60

// Stage 7 (b22): pre-lock log buffer. Lines produced before file logging
// enables (init banner, lock branch) are held here and flushed to the file
// the moment it opens - the file log is blind to startup otherwise
// (found Stage 7 Run 1: lock evidence lived only in the Experts tab).
// On a REFUSED init the buffer dies with the instance (matrix D2) - the
// lines were already Print()ed to the Experts tab, nothing is silent.
#define PRELOCK_BUF_MAX 50
string g_preLockBuf[PRELOCK_BUF_MAX];
int    g_preLockN       = 0;
int    g_preLockDropped = 0;   // lines dropped past the cap (marker on flush, matrix D3)

//+------------------------------------------------------------------+
//| SEQUENCE STATE                                                   |
//| Everything needed to describe one managed trade sequence.        |
//| Reconstructable-from-terminal fields are rebuilt on init;        |
//| non-reconstructable flags are the reason this struct persists.   |
//+------------------------------------------------------------------+
struct SequenceState
  {
   // --- identity ---
   int      schema;             // state file schema version
   string   symbol;             // chart symbol at save time
   long     magic;              // EA magic
   // --- sequence (reconstructable, stored for cross-check only) ---
   int      direction;          // 0 = flat, 1 = buy, -1 = sell
   int      levelCount;         // number of live levels
   ulong    tickets[TRTM_MAX_LEVELS];
   int      levels[TRTM_MAX_LEVELS];   // level number per ticket (parsed from comment)
   // --- non-reconstructable flags (the real payload) ---
   double   baseLot;            // L1 original volume: recovery lot base (survives L1 close)
   bool     adoptedL1;          // L1 is an external (magic 0) trade adopted via comment tag
   bool     trailOverride;      // button-enabled trailing (per sequence)
   bool     beOverride;         // button-enabled BE (per sequence)
   bool     trailingActive;     // trail trigger already hit; TP removed; toggle-off refused
   bool     beApplied;          // BE SL already placed; toggle-off refused
   // --- Stage 8 (b24): manual exit ownership (matrix D2/D7) ---
   double   manualTP;           // trader-owned TP (0 = not owned). Releases on structural
                                // events: level add / level close / trail-arm.
   double   manualSL;           // trader-owned SL (0 = not owned). PERSISTS across structure
                                // changes (locked: trader's risk statement + level budget);
                                // ends only on flat / re-edit / BE-trail supersession.
   datetime adoptionTime;       // when L1 was adopted; intervals evaluated from here forward
   datetime lastCloseTime;      // when the previous sequence fully closed (stale-tag gate)
   datetime lastSaved;
  };

//+------------------------------------------------------------------+
//| GLOBALS                                                          |
//+------------------------------------------------------------------+
SequenceState g_state;
long          g_magic       = 0;
string        g_symbolNorm  = "";     // normalized chart symbol, e.g. XAUUSD
string        g_stateFile   = "";     // TRTM\state_SYMBOL_MAGIC.json
int           g_logHandle   = INVALID_HANDLE;
string        g_logDate     = "";     // yyyymmdd of the open log file (daily rotation)
bool          g_fileLogEnabled = false; // true only after instance lock acquired
bool          g_logFileFailed  = false; // sticky: one open-failure disables file logging

//+------------------------------------------------------------------+
//| LOGGING                                                          |
//| Every failure or skip in this EA MUST route through Log().       |
//| Daily rotation: one file per day, opened lazily, rotated on the  |
//| first log call after midnight.                                   |
//+------------------------------------------------------------------+
string LogLevelText(const int level)
  {
   if(level == LOG_WARN)  return "WARN ";
   if(level == LOG_ERROR) return "ERROR";
   return "INFO ";
  }

void LogRotateIfNeeded()
  {
   if(!InpLogToFile || !g_fileLogEnabled || g_logFileFailed)
      return;
   string today = TimeToString(TimeCurrent(), TIME_DATE); // yyyy.mm.dd
   StringReplace(today, ".", "");
   if(today == g_logDate && g_logHandle != INVALID_HANDLE)
      return;
   if(g_logHandle != INVALID_HANDLE)
     {
      FileClose(g_logHandle);
      g_logHandle = INVALID_HANDLE;
     }
   string path = TRTM_DIR_BASE + "log_" + g_symbolNorm + "_" +
                 (string)g_magic + "_" + today + ".log";
   g_logHandle = FileOpen(path, FILE_READ | FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_SHARE_READ);
   if(g_logHandle == INVALID_HANDLE)
     {
      // Log file unavailable: fall back to terminal log only, but SAY so.
      PrintFormat("[%s][ERROR] cannot open log file '%s' (err %d) - file logging disabled this session",
                  TRTM_TAG, path, GetLastError());
      g_logFileFailed = true;
      return;
     }
   FileSeek(g_logHandle, 0, SEEK_END);
   g_logDate = today;
   LogCleanup();   // b22: retention pass on every new file open (init + daily
                   // rotation) - recursion-safe: Log() -> rotate returns early
                   // now that today's file is open.
  }

//+------------------------------------------------------------------+
//| LOG RETENTION (Stage 7, b22)                                     |
//| Deletes ONLY this instance's own files:                          |
//|   log_<SYMBOL>_<MAGIC>_YYYYMMDD.log                              |
//| Date parsed from the FILENAME (file attributes lie after copies).|
//| Anything that does not parse cleanly is SKIPPED, never deleted   |
//| (matrix E3). State files and other symbols/magics untouched      |
//| (E4/E7). 0 = keep forever (E2). Failures WARN and continue (E6). |
//+------------------------------------------------------------------+
void LogCleanup()
  {
   if(InpLogRetentionDays <= 0)
      return;
   string prefix = "log_" + g_symbolNorm + "_" + (string)g_magic + "_";
   string mask   = TRTM_DIR_BASE + prefix + "*.log";
   datetime cutoff = TimeCurrent() - (datetime)InpLogRetentionDays * 86400;
   int deleted = 0;
   string oldestKept = "";
   string fname;
   long   search = FileFindFirst(mask, fname);
   if(search == INVALID_HANDLE)
      return;   // nothing matches - nothing to do, silence is correct here (E2 spirit)
   do
     {
      // Defensive re-check: the mask should guarantee this, but a delete
      // must never ride on an assumption about FileFindFirst semantics
      // (some builds return names with the subdirectory prefixed - strip it).
      if(StringFind(fname, TRTM_DIR_BASE) == 0)
         fname = StringSubstr(fname, StringLen(TRTM_DIR_BASE));
      if(StringFind(fname, prefix) != 0 || StringLen(fname) != StringLen(prefix) + 12)
         continue;                                   // E3: not our exact pattern - skip
      string dpart = StringSubstr(fname, StringLen(prefix), 8);   // yyyymmdd
      bool digits = true;
      for(int i = 0; i < 8; i++)
         if(StringGetCharacter(dpart, i) < '0' || StringGetCharacter(dpart, i) > '9')
           { digits = false; break; }
      if(!digits)
         continue;                                   // E3: malformed date - skip
      datetime fdate = StringToTime(StringSubstr(dpart, 0, 4) + "." +
                                    StringSubstr(dpart, 4, 2) + "." +
                                    StringSubstr(dpart, 6, 2));
      if(fdate == 0)
         continue;                                   // E3: unparseable - skip
      if(fdate >= cutoff)
        {
         if(oldestKept == "" || dpart < oldestKept) oldestKept = dpart;
         continue;                                   // E5: in window - keep
        }
      if(FileDelete(TRTM_DIR_BASE + fname))
         deleted++;
      else
         Log(LOG_WARN, StringFormat("Log cleanup: cannot delete '%s' (err %d) - continuing", fname, GetLastError()));   // E6
     }
   while(FileFindNext(search, fname));
   FileFindClose(search);
   if(deleted > 0)
      Log(LOG_INFO, StringFormat("Log cleanup: %d file(s) older than %dd deleted%s",
                                 deleted, InpLogRetentionDays,
                                 oldestKept != "" ? " (oldest kept: " + oldestKept + ")" : ""));   // E1
  }

void Log(const int level, const string msg)
  {
   if(g_cfgCapture && level == LOG_ERROR && g_cfgReason == "")
      g_cfgReason = msg;   // b17: first validation error -> warning row
   string line = StringFormat("[%s][%s] %s", TRTM_TAG, LogLevelText(level), msg);
   Print(line);
   string stamped = TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS) + " " + line;
   // b22 (D1/D3): before the lock, hold the line for the file - Print above
   // already reached the Experts tab, so nothing is ever silent.
   if(InpLogToFile && !g_fileLogEnabled && !g_logFileFailed)
     {
      if(g_preLockN < PRELOCK_BUF_MAX) g_preLockBuf[g_preLockN++] = stamped;
      else                             g_preLockDropped++;
      return;
     }
   LogRotateIfNeeded();
   if(g_logHandle != INVALID_HANDLE)
     {
      // b22 (D1): startup lines buffered pre-lock go in first, once, in order.
      if(g_preLockN > 0)
        {
         for(int i = 0; i < g_preLockN; i++)
            FileWrite(g_logHandle, g_preLockBuf[i]);
         if(g_preLockDropped > 0)
            FileWrite(g_logHandle, StringFormat("[%s][WARN ] (%d pre-lock line(s) truncated - buffer cap %d)",
                                                TRTM_TAG, g_preLockDropped, PRELOCK_BUF_MAX));
         g_preLockN = 0;
         g_preLockDropped = 0;
        }
      FileWrite(g_logHandle, stamped);
      FileFlush(g_logHandle);
     }
  }

//+------------------------------------------------------------------+
//| SYMBOL NORMALIZATION                                             |
//| "XAUUSD.m", "pro.XAUUSD", "XAUUSDmicro" -> comparable core.      |
//| Stage 1 use: magic derivation + file naming (chart symbol only). |
//| Stage 2 will reuse this for comment-tag matching.                |
//+------------------------------------------------------------------+
string NormalizeSymbol(const string raw)
  {
   string out = "";
   for(int i = 0; i < StringLen(raw); i++)
     {
      ushort c = StringGetCharacter(raw, i);
      if((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
         out += ShortToString(c);
      else if(c >= 'a' && c <= 'z')
         out += ShortToString((ushort)(c - 32));
      // separators (. - _ /) dropped
     }
   return out;
  }

//+------------------------------------------------------------------+
//| MAGIC DERIVATION                                                 |
//| Deterministic from normalized symbol ONLY (not chart ID):        |
//| same symbol always regenerates the same magic, surviving both    |
//| terminal restarts and chart re-creation. Range: 700000-799999.   |
//+------------------------------------------------------------------+
long DeriveMagic(const string symbolNorm)
  {
   ulong h = 1469598103934665603; // FNV-1a 64-bit offset basis
   for(int i = 0; i < StringLen(symbolNorm); i++)
     {
      h ^= (ulong)StringGetCharacter(symbolNorm, i);
      h *= 1099511628211;
     }
   return (long)(700000 + (h % 100000));
  }

//+------------------------------------------------------------------+
//| STATE: DEFAULTS                                                  |
//+------------------------------------------------------------------+
void StateReset(SequenceState &s)
  {
   s.schema        = TRTM_STATE_SCHEMA;
   s.symbol        = g_symbolNorm;
   s.magic         = g_magic;
   s.direction     = 0;
   s.levelCount    = 0;
   ArrayInitialize(s.tickets, 0);
   ArrayInitialize(s.levels, 0);
   s.baseLot        = 0.0;
   s.adoptedL1      = false;
   s.trailOverride  = false;
   s.beOverride     = false;
   s.trailingActive = false;
   s.beApplied      = false;
   s.manualTP       = 0.0;
   s.manualSL       = 0.0;
   s.adoptionTime   = 0;
   s.lastCloseTime  = 0;   // callers that reset after a close must re-set this AFTER StateReset
   s.lastSaved      = 0;
  }

//+------------------------------------------------------------------+
//| STATE: SERIALIZE (flat JSON, hand-rolled - fixed schema)         |
//+------------------------------------------------------------------+
string StateToJson(const SequenceState &s)
  {
   string tickets = "", levels = "";
   for(int i = 0; i < s.levelCount && i < TRTM_MAX_LEVELS; i++)
     {
      if(i > 0) { tickets += ","; levels += ","; }
      tickets += (string)s.tickets[i];
      levels  += (string)s.levels[i];
     }
   string json = "{";
   json += "\"schema\":"         + (string)s.schema + ",";
   json += "\"symbol\":\""       + s.symbol + "\",";
   json += "\"magic\":"          + (string)s.magic + ",";
   json += "\"direction\":"      + (string)s.direction + ",";
   json += "\"levelCount\":"     + (string)s.levelCount + ",";
   json += "\"tickets\":["       + tickets + "],";
   json += "\"levels\":["        + levels + "],";
   json += "\"baseLot\":"        + DoubleToString(s.baseLot, 8) + ",";
   json += "\"adoptedL1\":"      + (s.adoptedL1      ? "true" : "false") + ",";
   json += "\"trailOverride\":"  + (s.trailOverride  ? "true" : "false") + ",";
   json += "\"beOverride\":"     + (s.beOverride     ? "true" : "false") + ",";
   json += "\"trailingActive\":" + (s.trailingActive ? "true" : "false") + ",";
   json += "\"beApplied\":"      + (s.beApplied      ? "true" : "false") + ",";
   json += "\"manualTP\":"       + DoubleToString(s.manualTP, 8) + ",";
   json += "\"manualSL\":"       + DoubleToString(s.manualSL, 8) + ",";
   json += "\"adoptionTime\":"   + (string)((long)s.adoptionTime) + ",";
   json += "\"lastCloseTime\":"  + (string)((long)s.lastCloseTime) + ",";
   json += "\"lastSaved\":"      + (string)((long)TimeCurrent());
   json += "}";
   return json;
  }

//+------------------------------------------------------------------+
//| STATE: PARSE HELPERS (fixed known schema; not a generic parser)  |
//+------------------------------------------------------------------+
bool JsonFindRaw(const string json, const string key, string &raw)
  {
   string needle = "\"" + key + "\":";
   int p = StringFind(json, needle);
   if(p < 0)
      return false;
   p += StringLen(needle);
   int endComma = StringFind(json, ",", p);
   int endBrace = StringFind(json, "}", p);
   int e = (endComma >= 0 && endComma < endBrace) ? endComma : endBrace;
   if(e < 0)
      return false;
   raw = StringSubstr(json, p, e - p);
   StringTrimLeft(raw);
   StringTrimRight(raw);
   return true;
  }

bool JsonGetLong(const string json, const string key, long &val)
  {
   string raw;
   if(!JsonFindRaw(json, key, raw)) return false;
   val = StringToInteger(raw);
   return true;
  }

bool JsonGetDouble(const string json, const string key, double &val)
  {
   string raw;
   if(!JsonFindRaw(json, key, raw)) return false;
   val = StringToDouble(raw);
   return true;
  }

bool JsonGetBool(const string json, const string key, bool &val)
  {
   string raw;
   if(!JsonFindRaw(json, key, raw)) return false;
   val = (StringFind(raw, "true") >= 0);
   return true;
  }

bool JsonGetString(const string json, const string key, string &val)
  {
   string raw;
   if(!JsonFindRaw(json, key, raw)) return false;
   StringReplace(raw, "\"", "");
   val = raw;
   return true;
  }

bool JsonGetArray(const string json, const string key, long &arr[], int &count)
  {
   string needle = "\"" + key + "\":[";
   int p = StringFind(json, needle);
   if(p < 0)
      return false;
   p += StringLen(needle);
   int e = StringFind(json, "]", p);
   if(e < 0)
      return false;
   string body = StringSubstr(json, p, e - p);
   count = 0;
   if(StringLen(body) == 0)
      return true;
   string parts[];
   int n = StringSplit(body, ',', parts);
   for(int i = 0; i < n && i < TRTM_MAX_LEVELS; i++)
     {
      arr[i] = StringToInteger(parts[i]);
      count++;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| STATE: SAVE / LOAD / DELETE                                      |
//| Called on every state transition (later stages) + init/deinit.   |
//+------------------------------------------------------------------+
bool StateSave(const SequenceState &s)
  {
   int h = FileOpen(g_stateFile, FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(h == INVALID_HANDLE)
     {
      Log(LOG_ERROR, StringFormat("StateSave failed: cannot open '%s' (err %d)", g_stateFile, GetLastError()));
      return false;
     }
   FileWriteString(h, StateToJson(s));
   FileClose(h);
   return true;
  }

bool StateLoad(SequenceState &s)
  {
   if(!FileIsExist(g_stateFile))
      return false; // not an error: first run or clean shutdown after flat
   int h = FileOpen(g_stateFile, FILE_READ | FILE_TXT | FILE_ANSI);
   if(h == INVALID_HANDLE)
     {
      Log(LOG_ERROR, StringFormat("StateLoad failed: file exists but cannot open '%s' (err %d)", g_stateFile, GetLastError()));
      return false;
     }
   string json = "";
   while(!FileIsEnding(h))
      json += FileReadString(h);
   FileClose(h);

   long tmp;
   if(!JsonGetLong(json, "schema", tmp) || tmp != TRTM_STATE_SCHEMA)
     {
      Log(LOG_WARN, StringFormat("StateLoad: schema mismatch or missing (found %d, expected %d) - discarding file", (int)tmp, TRTM_STATE_SCHEMA));
      return false;
     }
   StateReset(s);
   JsonGetString(json, "symbol", s.symbol);
   if(JsonGetLong(json, "magic", tmp))        s.magic = tmp;
   if(JsonGetLong(json, "direction", tmp))    s.direction = (int)tmp;
   if(JsonGetLong(json, "levelCount", tmp))   s.levelCount = (int)tmp;

   long larr[TRTM_MAX_LEVELS];
   int  n = 0;
   if(JsonGetArray(json, "tickets", larr, n))
      for(int i = 0; i < n; i++) s.tickets[i] = (ulong)larr[i];
   if(JsonGetArray(json, "levels", larr, n))
      for(int i = 0; i < n; i++) s.levels[i] = (int)larr[i];

   JsonGetDouble(json, "baseLot",      s.baseLot);
   JsonGetBool(json, "adoptedL1",      s.adoptedL1);
   JsonGetBool(json, "trailOverride",  s.trailOverride);
   JsonGetBool(json, "beOverride",     s.beOverride);
   JsonGetBool(json, "trailingActive", s.trailingActive);
   JsonGetBool(json, "beApplied",      s.beApplied);
   s.manualTP = 0.0;   // b24: explicit default BEFORE parse - MQL5 locals are
   s.manualSL = 0.0;   // not auto-initialized; absent key MUST mean "not owned" (M1-4)
   JsonGetDouble(json, "manualTP",     s.manualTP);
   JsonGetDouble(json, "manualSL",     s.manualSL);
   if(JsonGetLong(json, "adoptionTime", tmp)) s.adoptionTime = (datetime)tmp;
   if(JsonGetLong(json, "lastCloseTime", tmp)) s.lastCloseTime = (datetime)tmp;
   if(JsonGetLong(json, "lastSaved", tmp))    s.lastSaved = (datetime)tmp;

   // Sanity: file must belong to this chart's symbol+magic
   if(s.symbol != g_symbolNorm || s.magic != g_magic)
     {
      Log(LOG_ERROR, StringFormat("StateLoad: file identity mismatch (file %s/%d vs chart %s/%d) - discarding",
                                  s.symbol, (int)s.magic, g_symbolNorm, (int)g_magic));
      return false;
     }
   return true;
  }

// NOTE (b2): the state file is never deleted anymore. A closed sequence
// writes a "flat marker" (levelCount=0 + lastCloseTime) which anchors the
// stale-tag adoption gate across restarts.

//+------------------------------------------------------------------+
//| ADOPTION ENGINE (Stage 2)                                        |
//| Tag format: (symbol)_l(N)_(buy|sell), e.g. xauusd_l1_sell.       |
//| Rules locked in design:                                          |
//|  - contains-based, case-insensitive matching                     |
//|  - symbol match is bidirectional contains (broker suffixes)      |
//|  - direction mismatch tag vs position -> NO adoption, error log  |
//|  - first valid tagged trade wins; others ignored (logged once)   |
//|  - adoption stamps adoptionTime: recovery intervals evaluate     |
//|    from here forward only (no-retroactive rule)                  |
//|  - TP/SL overwrite on adoption is Stage 3 (ExitEngine)           |
//| NOTE: MT5 cannot modify POSITION_MAGIC. Adopted L1 stays magic 0 |
//| forever; it is tracked by ticket in state and re-found on        |
//| restart by the tag scan in RebuildLiveMap (pass 2).              |
//+------------------------------------------------------------------+
string g_loggedKeys[];   // "context:ticket" keys already warned (log-once per condition)

// Stage 5 dashboard warning slot (in-memory, like the log-once registry):
// g_dashWarn while a sequence is live (duplicate tag / unmanaged manual),
// g_dashMMTNotice while flat (b9-1: adoptable candidate but MMT off).
string g_dashWarn      = "";
string g_dashMMTNotice = "";

bool AlreadyLogged(const string key)
  {
   for(int i = 0; i < ArraySize(g_loggedKeys); i++)
      if(g_loggedKeys[i] == key)
         return true;
   int n = ArraySize(g_loggedKeys);
   ArrayResize(g_loggedKeys, n + 1);
   g_loggedKeys[n] = key;
   return false;
  }

// Parses "(symbol)_l(N)_(buy|sell)" out of a comment (extra broker text
// before/after tolerated). Returns false if no valid tag found.
bool ParseTag(const string comment, string &symPart, int &level, int &dir)
  {
   string c = comment;
   StringToLower(c);
   int p = StringFind(c, "_l");
   while(p >= 0)
     {
      int q = StringFind(c, "_", p + 2);
      if(q > p + 2)
        {
         string numPart = StringSubstr(c, p + 2, q - (p + 2));
         bool numeric = StringLen(numPart) > 0;
         for(int i = 0; i < StringLen(numPart) && numeric; i++)
           {
            ushort ch = StringGetCharacter(numPart, i);
            if(ch < '0' || ch > '9') numeric = false;
           }
         if(numeric)
           {
            string tail = StringSubstr(c, q + 1);
            int d = 0;
            if(StringFind(tail, "buy") == 0)  d = 1;
            if(StringFind(tail, "sell") == 0) d = -1;
            if(d != 0)
              {
               symPart = NormalizeSymbol(StringSubstr(c, 0, p));
               level   = (int)StringToInteger(numPart);
               dir     = d;
               return true;
              }
           }
        }
      p = StringFind(c, "_l", p + 2);
     }
   return false;
  }

// Bidirectional contains: chart GBPAUDS matches tag gbpaud and vice versa.
bool TagSymbolMatches(const string tagSym)
  {
   if(StringLen(tagSym) == 0)
      return false;
   return (StringFind(g_symbolNorm, tagSym) >= 0 || StringFind(tagSym, g_symbolNorm) >= 0);
  }

// Shared adoption action for tagged and untagged paths.
void AdoptPosition(const ulong ticket, const int posDir, const bool untagged, const string comment)
  {
   datetime keepLastClose = g_state.lastCloseTime;
   StateReset(g_state);
   g_state.lastCloseTime = keepLastClose;
   g_state.direction    = posDir;
   g_state.levelCount   = 1;
   g_state.tickets[0]   = ticket;
   g_state.levels[0]    = 1;
   g_state.adoptedL1    = true;
   g_state.baseLot      = PositionGetDouble(POSITION_VOLUME);
   g_state.adoptionTime = TimeCurrent();
   ResetExitEnforcement();
   CancelOwnPendingOrders("sequence started (adoption)");   // P8: never let our pending fill into a live sequence
   StateSave(g_state);
   LogStructure();
   Log(LOG_INFO, StringFormat("ADOPTED %sL1: ticket %I64u %s %.2f lots @ %s (comment '%s'). Exits apply next tick.",
                              untagged ? "UNTAGGED " : "", ticket, posDir > 0 ? "BUY" : "SELL",
                              PositionGetDouble(POSITION_VOLUME),
                              DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), _Digits),
                              comment));
   if(untagged)
      Alert(StringFormat("TRTM %s: adopted UNTAGGED manual trade %I64u as L1", g_symbolNorm, ticket));
  }

// Scans for an external tagged L1 to adopt. Only called when FLAT.
// If nothing tagged qualifies and InpManageMobileTrades is on, falls back to
// the OLDEST untagged, strictly magic-0 manual position (mobile workflow:
// the standard MT5 mobile app has no comment field).
void TryAdopt()
  {
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionGetInteger(POSITION_MAGIC) == g_magic)
         continue;   // our own trades are not adoption candidates
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;   // primary filter: must be this chart's instrument

      string comment = PositionGetString(POSITION_COMMENT);
      string symPart; int level, tagDir;
      if(!ParseTag(comment, symPart, level, tagDir))
         continue;   // untagged manual trade: none of our business

      // Stale-tag gate: only positions opened AFTER the previous sequence
      // fully closed are adoptable. A duplicate tagged mid-sequence is
      // automatically stale once that sequence ends - it can never queue.
      if(g_state.lastCloseTime > 0 &&
         (datetime)PositionGetInteger(POSITION_TIME) < g_state.lastCloseTime)
        {
         if(!AlreadyLogged("stale:" + (string)ticket))
            Log(LOG_WARN, StringFormat("Adoption: ticket %I64u tagged L1 but opened BEFORE last sequence close - stale tag, will never be auto-adopted. Close or manage it manually.", ticket));
         continue;
        }

      if(level != 1)
        {
         if(!AlreadyLogged("lvl:" + (string)ticket))
            Log(LOG_WARN, StringFormat("Adoption: ticket %I64u tagged level %d - only _l1_ tags are adoptable, ignored", ticket, level));
         continue;
        }
      if(!TagSymbolMatches(symPart))
        {
         if(!AlreadyLogged("sym:" + (string)ticket))
            Log(LOG_WARN, StringFormat("Adoption: ticket %I64u tag symbol '%s' does not match chart '%s' - ignored", ticket, symPart, g_symbolNorm));
         continue;
        }
      int posDir = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 1 : -1;
      if(posDir != tagDir)
        {
         if(!AlreadyLogged("dir:" + (string)ticket))
            Log(LOG_ERROR, StringFormat("Adoption REFUSED: ticket %I64u tag says %s but position is %s - direction mismatch", ticket, tagDir > 0 ? "BUY" : "SELL", posDir > 0 ? "BUY" : "SELL"));
         continue;
        }

      // First valid tagged L1 wins.
      AdoptPosition(ticket, posDir, false, comment);
      return;
     }

   // --- Untagged fallback (mobile workflow) ---
   // b9-1: the scan now runs even with Manage Mobile Trades OFF, so a
   // qualifying candidate that will NOT be adopted is announced once
   // instead of silently ignored (the silent off-switch cost real test
   // time on 2026-07-13). With MMT off, nothing is ever adopted here.
   ulong    bestTicket = 0;
   int      bestDir    = 0;
   datetime bestTime   = 0;
   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionGetInteger(POSITION_MAGIC) != 0)
         continue;   // strictly manual trades - never another EA's position
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;
      string symPart; int level, tagDir;
      if(ParseTag(PositionGetString(POSITION_COMMENT), symPart, level, tagDir))
         continue;   // has a tag: tagged rules already judged it, not a fallback candidate
      datetime opened = (datetime)PositionGetInteger(POSITION_TIME);
      if(g_state.lastCloseTime > 0 && opened < g_state.lastCloseTime)
        {
         // Stale WARN only matters when the fallback is armed - with MMT
         // off the trade was never a candidate, warning would be noise.
         if(InpManageMobileTrades && !AlreadyLogged("stale:" + (string)ticket))
            Log(LOG_WARN, StringFormat("Adoption: untagged ticket %I64u opened BEFORE last sequence close - stale, will never be auto-adopted", ticket));
         continue;
        }
      if(bestTicket == 0 || opened < bestTime)
        {
         bestTicket = ticket;
         bestTime   = opened;
         bestDir    = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 1 : -1;
        }
     }
   if(bestTicket == 0)
     {
      g_dashMMTNotice = "";   // no candidate: clear the dashboard notice
      return;
     }
   if(!InpManageMobileTrades)
     {
      // b9-1: one-shot INFO + persistent dashboard notice. NOT adopted.
      if(!AlreadyLogged("mmtoff:" + (string)bestTicket))
         Log(LOG_INFO, StringFormat("Untagged manual trade %I64u qualifies for adoption but Manage Mobile Trades is OFF - it will NOT be adopted. Enable the input (or tag the trade) if TRTM should manage it.", bestTicket));
      g_dashMMTNotice = StringFormat("candidate %I64u NOT adopted: MMT off", bestTicket);
      return;
     }
   if(!PositionSelectByTicket(bestTicket))
     {
      Log(LOG_WARN, StringFormat("Adoption: untagged candidate %I64u vanished before adoption - skipped this tick", bestTicket));
      return;
     }
   g_dashMMTNotice = "";
   AdoptPosition(bestTicket, bestDir, true, PositionGetString(POSITION_COMMENT));
  }

// b20 ride-along (Jeff, after the S6-6 run): a broker-side TP/SL fill is
// the EA's OWN configured exit doing its job - logging it "closed
// externally" was a misattribution. Read the closing deal's reason from
// history; "closed externally" is reserved for manual/unknown closes.
// Returns: 1 TP fill, 2 SL fill, 3 stop-out, 0 unknown/manual.
int ClosingDealReason(const ulong posTicket, double &closePx)
  {
   closePx = 0.0;
   if(!HistorySelectByPosition((long)posTicket))
      return 0;
   for(int d = HistoryDealsTotal() - 1; d >= 0; d--)
     {
      ulong deal = HistoryDealGetTicket(d);
      if(deal == 0) continue;
      if((ENUM_DEAL_ENTRY)HistoryDealGetInteger(deal, DEAL_ENTRY) != DEAL_ENTRY_OUT)
         continue;
      closePx = HistoryDealGetDouble(deal, DEAL_PRICE);
      switch((ENUM_DEAL_REASON)HistoryDealGetInteger(deal, DEAL_REASON))
        {
         case DEAL_REASON_TP: return 1;
         case DEAL_REASON_SL: return 2;
         case DEAL_REASON_SO: return 3;
         default:             return 0;
        }
     }
   return 0;
  }

// Verifies all tracked tickets still exist at the broker. Externally
// closed levels are removed (logged); empty sequence -> back to FLAT.
void CheckSequenceLiveness()
  {
   bool changed = false;
   for(int i = g_state.levelCount - 1; i >= 0; i--)
     {
      if(PositionSelectByTicket(g_state.tickets[i]))
         continue;
      if(WasEAClosed(g_state.tickets[i]))   // b9-2: EA's own market close
         Log(LOG_INFO, StringFormat("Liveness: L%d ticket %I64u closed by EA (market close) - removed from sequence", g_state.levels[i], g_state.tickets[i]));
      else
        {
         // b20: broker-side exits attributed as what they are.
         double cpx = 0.0;
         int reason = ClosingDealReason(g_state.tickets[i], cpx);
         if(reason == 1)
            Log(LOG_INFO, StringFormat("Liveness: L%d ticket %I64u TP hit @ %s - removed from sequence", g_state.levels[i], g_state.tickets[i], DoubleToString(cpx, _Digits)));
         else if(reason == 2)
            Log(LOG_INFO, StringFormat("Liveness: L%d ticket %I64u SL hit @ %s - removed from sequence", g_state.levels[i], g_state.tickets[i], DoubleToString(cpx, _Digits)));
         else if(reason == 3)
            Log(LOG_WARN, StringFormat("Liveness: L%d ticket %I64u STOP-OUT @ %s (margin call) - removed from sequence", g_state.levels[i], g_state.tickets[i], DoubleToString(cpx, _Digits)));
         else
            Log(LOG_WARN, StringFormat("Liveness: L%d ticket %I64u closed externally (manual/unknown) - removed from sequence", g_state.levels[i], g_state.tickets[i]));
        }
      for(int j = i; j < g_state.levelCount - 1; j++)
        {
         g_state.tickets[j] = g_state.tickets[j + 1];
         g_state.levels[j]  = g_state.levels[j + 1];
        }
      g_state.levelCount--;
      changed = true;
     }
   if(!changed)
      return;
   if(g_state.levelCount > 0)
     {
      ReleaseManualTP("level close");   // b24 structural release; manual SL persists (M7-4)
      LogStructure();
     }
   if(g_state.levelCount == 0)
     {
      Log(LOG_INFO, "Sequence fully closed - back to FLAT, overrides reset to input defaults, flat marker saved");
      datetime closeTime = TimeCurrent();
      StateReset(g_state);
      g_state.lastCloseTime = closeTime;   // stale-tag gate anchor
      ResetExitEnforcement();
      ArrayResize(g_eaClosed, 0);          // b9-2: attribution list is per-sequence
      StateSave(g_state);                  // flat marker (schema v3)
     }
   else
      StateSave(g_state);
  }

// While a sequence is active: any OTHER magic-0 position carrying a valid
// L1 tag is a user mistake waiting to happen. It is NOT managed and (thanks
// to the stale-tag gate) will NOT be auto-adopted later. Warn once, loudly.
void WatchDuplicateTags()
  {
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      if(PositionGetInteger(POSITION_MAGIC) == g_magic)
         continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;
      bool tracked = false;
      for(int j = 0; j < g_state.levelCount; j++)
         if(g_state.tickets[j] == ticket) { tracked = true; break; }
      if(tracked)
         continue;
      string symPart; int level, tagDir;
      bool hasTag = ParseTag(PositionGetString(POSITION_COMMENT), symPart, level, tagDir);
      if(hasTag)
        {
         if(level != 1 || !TagSymbolMatches(symPart))
            continue;
         g_dashWarn = StringFormat("DUP L1 TAG %I64u - not managed", ticket);   // Stage 5 warning row (dup outranks unmanaged)
         if(AlreadyLogged("dup:" + (string)ticket))
            continue;
         Log(LOG_WARN, StringFormat("DUPLICATE L1 TAG: ticket %I64u carries an L1 tag but sequence L1 is ticket %I64u. This position is NOT managed by TRTM and will NOT be auto-adopted. Close or manage it manually.", ticket, g_state.tickets[0]));
         Alert(StringFormat("TRTM %s: duplicate L1 tag on ticket %I64u - NOT managed!", g_symbolNorm, ticket));
        }
      else if(InpManageMobileTrades && PositionGetInteger(POSITION_MAGIC) == 0)
        {
         // Untagged mode's premise: every manual trade on this symbol
         // belongs to TRTM. One that appears mid-sequence is unmanaged.
         if(StringFind(g_dashWarn, "DUP") != 0)   // dup-tag warn outranks this slot
            g_dashWarn = StringFormat("UNMANAGED manual %I64u", ticket);
         if(AlreadyLogged("unmgd:" + (string)ticket))
            continue;
         Log(LOG_WARN, StringFormat("UNMANAGED MANUAL TRADE: ticket %I64u present during an active sequence with Manage Mobile Trades ON. It is NOT managed and will NOT be auto-adopted. Close or manage it manually.", ticket));
         Alert(StringFormat("TRTM %s: unmanaged manual trade %I64u - NOT managed!", g_symbolNorm, ticket));
        }
     }
  }

//+------------------------------------------------------------------+
//| EXIT ENGINE (Stage 3)                                            |
//| Policy A: computed values are truth. Manual TP/SL changes are    |
//| reverted on the next tick with a WARN. (Policy B - yield to      |
//| manual changes + draggable exit lines - is spec'd in the README  |
//| post-core list.)                                                 |
//| Active in Stage 3: L1-only Initial TP, anchored SL.              |
//| Written but DORMANT until Stage 4 creates multi-level sequences: |
//| avg-entry TP overwrite, SL re-anchoring to lowest surviving lvl. |
//+------------------------------------------------------------------+
CTrade g_trade;

// In-memory enforcement state. Deliberately NOT persisted: under policy A
// a restart simply recomputes and re-applies (scenario S7).
double   g_lastAppliedTP  = 0.0;
double   g_lastAppliedSL  = 0.0;
int      g_modifyFails    = 0;      // consecutive failures across attempts
datetime g_nextModifyTry  = 0;      // backoff gate
bool     g_modifyAlerted  = false;  // escalation Alert fired for this episode
datetime g_lastDeferLog   = 0;      // throttle for stops-level deferral WARNs

ulong g_appliedOnce[];     // tickets that have had exits applied at least once

bool HasAppliedExits(const ulong ticket)
  {
   for(int i = 0; i < ArraySize(g_appliedOnce); i++)
      if(g_appliedOnce[i] == ticket)
         return true;
   return false;
  }

void MarkExitsApplied(const ulong ticket)
  {
   if(HasAppliedExits(ticket))
      return;
   int n = ArraySize(g_appliedOnce);
   ArrayResize(g_appliedOnce, n + 1);
   g_appliedOnce[n] = ticket;
  }

int g_prevAnchorLvl = 0;   // for SL re-anchor detection (widen rule)
int g_curAnchorLvl  = 0;   // set by ComputeTargets each pass
//--- Stage 6 (b16) engine state. Persisted flags live in SequenceState
//--- (beApplied / trailingActive); these are in-memory helpers. g_trailCand
//--- holds the last evaluated candidate so the ratchet floor still applies
//--- on ticks between bar-close evaluations.
double   g_curAvgEntry  = 0.0;   // simple avg of open entries (BE/trail ref), set by ComputeTargets
double   g_trailCand    = 0.0;   // last evaluated trail SL candidate (0 = none yet)
datetime g_lastTrailBar = 0;     // one trail evaluation per InpTrailTF bar (bar-close mode)

void ResetExitEnforcement()
  {
   ArrayResize(g_appliedOnce, 0);
   g_prevAnchorLvl = 0;
   g_curAnchorLvl  = 0;
   g_lastAppliedTP = 0.0;
   g_lastAppliedSL = 0.0;
   g_curAvgEntry   = 0.0;
   g_trailCand     = 0.0;
   g_lastTrailBar  = 0;
   g_modifyFails   = 0;
   g_nextModifyTry = 0;
   g_modifyAlerted = false;
   g_lastDeferLog  = 0;
  }

//+------------------------------------------------------------------+
//| STAGE 8 (b27): BROKER EXIT GEOMETRY GUIDANCE (init one-shot)     |
//| Found live 2026-07-17: BE trigger 100 - offset 30 = 87 pts on a  |
//| 100-pt stops-level symbol means every BE stop is born INSIDE the |
//| broker minimum and defers until price extends - the trader must  |
//| know this at CONFIG time, not discover it in a WARN mid-trade.   |
//| Guidance only (notify-never-auto-close): nothing is blocked.     |
//+------------------------------------------------------------------+
void LogBrokerExitGeometry()
  {
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
      Log(LOG_WARN, "AutoTrading is OFF (toolbar Algo Trading button) - every entry, pending, and exit write will be rejected with 10027 until it is enabled");
   long stopsPts  = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   long freezePts = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_FREEZE_LEVEL);
   long minDist   = (long)MathMax((double)stopsPts, (double)freezePts);
   Log(LOG_INFO, StringFormat("Broker exit geometry (at init): stops level %d pts, freeze level %d pts - TP/SL closer than %d pts to price are DEFERRED until placeable",
                              (int)stopsPts, (int)freezePts, (int)minDist));
   if(minDist <= 0)
      return;
   int beDist = InpBETriggerPts - InpBEOffsetPts;
   if(beDist < (int)minDist)
      Log(LOG_WARN, StringFormat("BE geometry: Trigger %d - Offset %d = %d pts < broker minimum %d pts. Every BE stop will be born UNPLACEABLE and deferred; the SL-exceeded backstop still closes at the BE price, but the stop is NOT broker-held (not kill-proof). For a broker-held BE stop set Trigger >= Offset + %d pts (+ spread margin).",
                                 InpBETriggerPts, InpBEOffsetPts, beDist, (int)minDist, (int)minDist));
   if(InpTrailDistPts < (int)minDist)
      Log(LOG_WARN, StringFormat("Trail geometry: Distance %d pts < broker minimum %d pts. Every trail SL will sit inside the broker minimum and defer chronically. Set Trailing Distance >= %d pts (+ spread margin).",
                                 InpTrailDistPts, (int)minDist, (int)minDist));
  }

//+------------------------------------------------------------------+
//| STAGE 8 (b24): MANUAL EXIT OWNERSHIP - structural TP release     |
//| Manual TP releases when the structure it was set against changes |
//| (level add / level close / trail-arm): the idea behind the edit  |
//| is invalid once the arithmetic moves. Manual SL has NO release   |
//| path here by design (locked): it persists as the trader's risk   |
//| statement and level budget. Caller is responsible for StateSave. |
//+------------------------------------------------------------------+
void ReleaseManualTP(const string trigger)
  {
   if(g_state.manualTP <= 0.0)
      return;
   Log(LOG_WARN, StringFormat("Manual TP %s RELEASED - %s (structure changed: computed target re-asserted)",
                              DoubleToString(g_state.manualTP, _Digits), trigger));
   g_state.manualTP = 0.0;
  }

double NormalizePrice(const double price)
  {
   return NormalizeDouble(price, _Digits);
  }

// Computes the sequence's target TP and SL from current structure.
// tp/sl of 0.0 mean "not managed" (feature disabled).
void ComputeTargets(double &tp, double &sl)
  {
   tp = 0.0;
   sl = 0.0;
   if(g_state.levelCount == 0)
      return;
   int dir = g_state.direction;

   // Anchor = entry of the LOWEST level number still present (locked rule:
   // SL anchored to lowest surviving level; L1 while it lives, then L2...).
   double anchorEntry = 0.0;
   int    minLvl      = 2147483647;
   // Avg entry across all open levels (dormant until Stage 4: levelCount==1
   // means avg == L1 entry anyway).
   double sumPrice = 0.0;
   int    counted  = 0;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      if(!PositionSelectByTicket(g_state.tickets[i]))
         continue;   // liveness handles disappearance; skip this tick
      double entry = PositionGetDouble(POSITION_PRICE_OPEN);
      if(g_state.levels[i] < minLvl)
        {
         minLvl      = g_state.levels[i];
         anchorEntry = entry;
        }
      sumPrice += entry;
      counted++;
     }
   if(counted == 0)
      return;
   g_curAnchorLvl = minLvl;
   g_curAvgEntry  = sumPrice / counted;   // Stage 6: BE/trail reference (simple avg, locked structural)

   if(g_state.levelCount == 1)
     {
      if(InpInitialTPPts > 0)
         tp = NormalizePrice(anchorEntry + dir * InpInitialTPPts * _Point);
     }
   else
     {
      // DORMANT until Stage 4. NOTE for Stage 4 design review: spec defines
      // avg entry as the SIMPLE average of entry prices (per the worked
      // example). With unequal lots (martingale etc.) the volume-weighted
      // average is the financially meaningful anchor. Decision pending -
      // simple average implemented to match spec until then.
      if(InpAvgTPPts > 0)
         tp = NormalizePrice(sumPrice / counted + dir * InpAvgTPPts * _Point);
     }
   if(InpStopLossPts > 0)
     {
      sl = NormalizePrice(anchorEntry - dir * InpStopLossPts * _Point);
      // Stage 6 ride-along (queued Stage 3 item): a computed SL at/below zero
      // is silently unplaceable. Guard B blocks this geometry on the BUTTONS
      // only - an ADOPTED trade can still reach it. Treat as off, say so once.
      if(sl <= 0.0)
        {
         if(!AlreadyLogged("sl0off:" + (string)(long)g_state.adoptionTime))
            Log(LOG_WARN, StringFormat("Computed SL is %s (<= 0) - Stop Loss treated as OFF for this sequence (adopted-trade geometry; Guard B covers buttons only)",
                                       DoubleToString(sl, _Digits)));
         sl = 0.0;
        }
     }
  }

//+------------------------------------------------------------------+
//| STAGE 6 - BE / TRAILING ENGINES (b16)                             |
//| Both engines only produce DESIRED values; EnforceExits stays the  |
//| single writer of TP/SL. Merge rule: wantSL = protective max of    |
//| {anchor SL, BE SL, trail candidate, ratchet floor}. Locked        |
//| decisions D1-D4 (see README Stage 6 design rules).                |
//+------------------------------------------------------------------+

// Most-protective of two SL prices (0 = absent). Buy: higher wins.
double ProtectiveSL(const double a, const double b, const int dir)
  {
   if(a <= 0.0) return b;
   if(b <= 0.0) return a;
   return (dir > 0) ? MathMax(a, b) : MathMin(a, b);
  }

// Points needed to cover accrued swap + commission across the sequence
// (BE Auto Adjust). Commission: entry-leg deals from history, exit leg
// estimated equal to entry (symmetric). Rounded UP to the next point.
int CostCoverPoints()
  {
   double cost = 0.0;
   double vol  = 0.0;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      ulong ticket = g_state.tickets[i];
      if(!PositionSelectByTicket(ticket))
         continue;
      vol  += PositionGetDouble(POSITION_VOLUME);
      cost -= MathMin(0.0, PositionGetDouble(POSITION_SWAP));   // only adverse swap needs cover
      if(HistorySelectByPosition(PositionGetInteger(POSITION_IDENTIFIER)))
        {
         double comm = 0.0;
         for(int d = 0; d < HistoryDealsTotal(); d++)
           {
            ulong deal = HistoryDealGetTicket(d);
            if(deal == 0) continue;
            comm += MathAbs(HistoryDealGetDouble(deal, DEAL_COMMISSION));
           }
         cost += comm * 2.0;   // entry legs found so far; exit leg estimated = entry
        }
     }
   if(cost <= 0.0 || vol <= 0.0)
      return 0;
   double tickVal = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSz  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSz <= 0.0) tickSz = _Point;
   double perPoint = vol * tickVal * (_Point / tickSz);   // account ccy per point, whole sequence
   if(perPoint <= 0.0)
      return 0;
   return (int)MathCeil(cost / perPoint);
  }

// BE stop price for the current sequence (ref + offset [+ cost cover]).
double BEStopPrice()
  {
   if(g_curAvgEntry <= 0.0 || g_state.direction == 0)
      return 0.0;
   int pts = InpBEOffsetPts + (InpBEAutoAdjust ? CostCoverPoints() : 0);
   return NormalizePrice(g_curAvgEntry + g_state.direction * pts * _Point);
  }

// Trail activation price (D4 locked: ref + BE offset + trail distance).
double TrailActivationPrice()
  {
   if(g_curAvgEntry <= 0.0 || g_state.direction == 0)
      return 0.0;
   return NormalizePrice(g_curAvgEntry + g_state.direction * (InpBEOffsetPts + InpTrailDistPts) * _Point);
  }

// Called by EnforceExits right after ComputeTargets. Merges BE/trail into
// the desired tp/sl. Owns the one-shot trigger/activation transitions.
void ApplyProtectiveEngines(double &tp, double &sl)
  {
   if(g_state.levelCount == 0 || g_state.direction == 0 || g_curAvgEntry <= 0.0)
      return;
   int    dir      = g_state.direction;
   double profitPx = (dir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_BID)
                               : SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   //--- BE engine (D1: structural - ref + offset, cost cover on top) ---
   if(EffectiveBE())
     {
      if(!g_state.beApplied &&
         dir * (profitPx - g_curAvgEntry) >= InpBETriggerPts * _Point)
        {
         g_state.beApplied = true;   // one-time; toggle-off refused from here (locked)
         if(g_state.manualSL > 0.0)   // b27: D2 lock - manual SL ownership ends when BE arms
           {
            Log(LOG_INFO, StringFormat("Manual SL %s superseded - BE floor owns the stop from here (a TIGHTER manual edit can re-own it, M6-1)",
                                       DoubleToString(g_state.manualSL, _Digits)));
            g_state.manualSL = 0.0;
           }
         StateSave(g_state);
         double bePx = BEStopPrice();
         if(!AlreadyLogged("beapplied:" + (string)(long)g_state.adoptionTime))
            Log(LOG_INFO, StringFormat("BE TRIGGERED @ %s: SL -> %s (avg %s %s %d pts offset%s, profit side)",
                                       DoubleToString(profitPx, _Digits), DoubleToString(bePx, _Digits),
                                       DoubleToString(g_curAvgEntry, _Digits), (dir > 0) ? "+" : "-", InpBEOffsetPts,
                                       InpBEAutoAdjust ? StringFormat(" %s %d pts cost cover", (dir > 0) ? "+" : "-", CostCoverPoints()) : ""));
        }
      if(g_state.beApplied)
         sl = ProtectiveSL(sl, BEStopPrice(), dir);
     }

   //--- Trailing engine (D2: full bar-close discipline; D4: TP stays broker-
   //--- side until activation at ref + offset + distance) ---
   if(EffectiveTrail())
     {
      double evalPx = 0.0;
      bool   doEval = false;
      if(InpTrailBarClose)
        {
         datetime curBar = iTime(_Symbol, InpTrailTF, 0);
         if(curBar != g_lastTrailBar && curBar > 0)
           {
            g_lastTrailBar = curBar;          // one evaluation per bar, on its open =
            evalPx = iClose(_Symbol, InpTrailTF, 1);   // the just-CLOSED bar's close
            doEval = (evalPx > 0.0);
           }
        }
      else
        {
         evalPx = profitPx;
         doEval = true;
        }
      if(doEval)
        {
         if(!g_state.trailingActive &&
            dir * (evalPx - g_curAvgEntry) >= (InpBEOffsetPts + InpTrailDistPts) * _Point)
           {
            g_state.trailingActive = true;    // gates recovery (Stage 4 wiring); toggle-off refused (locked)
            ReleaseManualTP("trailing armed"); // b24: trail-arm is a structural TP release event
            if(g_state.manualSL > 0.0)         // b27: D2 lock - trail ratchet owns the stop from here
              {
               Log(LOG_INFO, StringFormat("Manual SL %s superseded - trail ratchet owns the stop from here (a TIGHTER manual edit becomes the ratchet floor, Stage 6 D3)",
                                          DoubleToString(g_state.manualSL, _Digits)));
               g_state.manualSL = 0.0;
              }
            StateSave(g_state);
            if(!AlreadyLogged("tractive:" + (string)(long)g_state.adoptionTime))
               Log(LOG_INFO, StringFormat("TRAILING ACTIVATED @ %s: TP removed, recovery gated, SL trails %d pts behind (%s mode)",
                                          DoubleToString(evalPx, _Digits), InpTrailDistPts,
                                          InpTrailBarClose ? EnumToString(InpTrailTF) + " bar-close" : "tick"));
           }
         if(g_state.trailingActive)
           {
            double cand = NormalizePrice(evalPx - dir * InpTrailDistPts * _Point);
            if(g_trailCand <= 0.0 || dir * (cand - g_trailCand) > 0.0)
               g_trailCand = cand;            // candidate itself never retreats
           }
        }
     }

   //--- trailing owns the exit: TP off, ratchet floor, min-step ---
   if(g_state.trailingActive)
     {
      tp = 0.0;                               // TP-exceeded close rule can never fire (IX4)
      sl = ProtectiveSL(sl, g_trailCand, dir);
      // Ratchet floor: broker SL (per D3 a manually TIGHTENED stop is adopted,
      // one-shot INFO) and the last EA-applied SL (so a manually LOOSENED stop
      // is still reverted per policy A - the WARN fires in EnforceExits).
      double brokerSL = 0.0;
      for(int i = 0; i < g_state.levelCount; i++)
        {
         if(!PositionSelectByTicket(g_state.tickets[i]))
            continue;
         brokerSL = ProtectiveSL(brokerSL, PositionGetDouble(POSITION_SL), dir);
        }
      double floorSL = ProtectiveSL(brokerSL, g_lastAppliedSL, dir);
      if(floorSL > 0.0)
        {
         double tol = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         if(tol <= 0.0) tol = _Point;
         tol /= 2.0;
         if(brokerSL > 0.0 && g_lastAppliedSL > 0.0 &&   // b21: after a restart the floor is our OWN pre-restart SL, not a manual edit
            dir * (brokerSL - g_lastAppliedSL) > tol &&
            dir * (brokerSL - ProtectiveSL(sl, 0.0, dir)) > tol &&
            !AlreadyLogged("ratchetadopt:" + DoubleToString(brokerSL, _Digits)))
            Log(LOG_INFO, StringFormat("Manual tighter SL %s adopted as ratchet floor (D3) - trailing resumes beyond it",
                                       DoubleToString(brokerSL, _Digits)));
         if(sl <= 0.0 || dir * (floorSL - sl) > 0.0)
            sl = floorSL;                     // never retreat behind the floor
         else if(dir * (sl - floorSL) < InpMinTrailStepPts * _Point)
            sl = floorSL;                     // min-step: advance too small, hold
        }
     }
  }

// Closes every tracked position at market. Used when the computed TP is
// already exceeded by price (decision: TP is a MINIMUM acceptable exit -
// being beyond it means the target is fulfilled; market-close banks >=
// target). State cleanup is left to the liveness pass (single source of
// truth for removals).
// b9-2: every ticket this function successfully closes is recorded so the
// liveness pass attributes it as an EA close, not "closed externally".
// In-memory only (cleared when the sequence goes flat) - after a restart
// the sequence is already reconciled, so no stale attribution is possible.
ulong g_eaClosed[];   // tickets closed by the EA itself this sequence

void MarkEAClosed(const ulong ticket)
  {
   int n = ArraySize(g_eaClosed);
   ArrayResize(g_eaClosed, n + 1);
   g_eaClosed[n] = ticket;
  }

bool WasEAClosed(const ulong ticket)
  {
   for(int i = 0; i < ArraySize(g_eaClosed); i++)
      if(g_eaClosed[i] == ticket)
         return true;
   return false;
  }

void CloseSequenceAtMarket(const string reason)
  {
   Log(LOG_INFO, StringFormat("Closing sequence at market: %s", reason));
   g_trade.SetExpertMagicNumber(g_magic);
   g_trade.SetDeviationInPoints(InpDeviationFilter ? (ulong)InpMaxDeviationPts : 1000000);
   for(int i = 0; i < g_state.levelCount; i++)
     {
      ulong ticket = g_state.tickets[i];
      if(!PositionSelectByTicket(ticket))
         continue;
      if(!g_trade.PositionClose(ticket))
        {
         if((int)g_trade.ResultRetcode() == 10036)   // b20: position already
            Log(LOG_INFO, StringFormat("Market close on ticket %I64u: broker exit filled first (10036) - benign race, liveness attributes it", ticket));
         else
            Log(LOG_ERROR, StringFormat("Market close FAILED on ticket %I64u (retcode %d: %s) - will retry while condition holds",
                                        ticket, (int)g_trade.ResultRetcode(), g_trade.ResultRetcodeDescription()));
        }
      else
        {
         MarkEAClosed(ticket);   // b9-2: liveness attributes this correctly
         Log(LOG_INFO, StringFormat("Closed L%d ticket %I64u @ %s", g_state.levels[i], ticket,
                                    DoubleToString(g_trade.ResultPrice(), _Digits)));
        }
     }
  }

// Applies computed TP/SL to every tracked position (idempotent, tolerant,
// broker-constraint aware, with backoff + escalation on failures).
//+------------------------------------------------------------------+
//| STAGE 8 (b24): MANUAL EXIT EDIT DETECTION (matrix M2-M6)         |
//| Runs before want-value substitution each pass. Classifies broker |
//| -side deltas on ARMED tickets (dressed at least once - b2 rule): |
//|   non-zero edit  -> ADOPT into manualTP/manualSL + propagate     |
//|                     (WARN with risk note if exposure-increasing, |
//|                      INFO otherwise - LOG SPEC)                  |
//|   conflict (>1 distinct value, one pass) -> adopt NONE, WARN;    |
//|                     the enforce loop reverts all (M4-1)          |
//|   post-BE looser SL -> REFUSED, WARN (floor never lowers, M6-2) |
//|   trailing active -> skipped: trail engine owns SL deltas via    |
//|                     the ratchet-adopt path; TP re-add stays      |
//|                     WARN+REMOVED in the enforce loop             |
//|   removal (->0)   -> never adopted; enforce loop reverts + WARN  |
//+------------------------------------------------------------------+
bool g_manualDetectSkipOnce = false; // set by ReconcileManualExits: first
                                     // pass after restart only propagates
                                     // what Reconcile already classified -
                                     // stale tickets must not read as edits

void DetectManualExitEdits(const double compTP, const double compSL)
  {
   if(g_manualDetectSkipOnce)
     { g_manualDetectSkipOnce = false; return; }   // designed sequencing, not a silent skip: Reconcile logged the classification
   if(g_state.levelCount == 0 || g_state.direction == 0)
      return;
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickVal  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tol      = (tickSize > 0.0 ? tickSize : _Point) / 2.0;
   int    dir      = g_state.direction;

   // Baseline = what the EA itself last wanted: owned manual, else computed.
   double baseTP = (g_state.manualTP > 0.0) ? g_state.manualTP : compTP;
   double baseSL = (g_state.manualSL > 0.0) ? g_state.manualSL : compSL;
   if(g_state.beApplied)
      baseSL = ProtectiveSL(baseSL, BEStopPrice(), dir);   // post-BE the floor is the baseline

   double candTP = 0.0, candSL = 0.0, totalLots = 0.0;
   bool   tpConflict = false, slConflict = false;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      if(!PositionSelectByTicket(g_state.tickets[i]))
         continue;
      totalLots += PositionGetDouble(POSITION_VOLUME);
      if(!HasAppliedExits(g_state.tickets[i]))
         continue;   // fresh position: 0/0 exits are initial placement, not an edit (b2)
      double curTP = PositionGetDouble(POSITION_TP);
      double curSL = PositionGetDouble(POSITION_SL);
      // b25 FIX (found live 2026-07-17): a candidate must differ from the
      // EA's OWN last-applied value too. After a structural recompute the
      // tickets legitimately carry the PREVIOUS computed value for one pass
      // (cur == lastApplied != new want) - that is the EA's stale write
      // awaiting rewrite, NOT a trader edit. b24 misread it as manual and
      // adopted its own value (TP oscillated adopt/release per level add;
      // SL variant would have frozen a stale anchor permanently).
      if(!g_state.trailingActive && baseTP > 0.0 && curTP > tol && MathAbs(curTP - baseTP) > tol &&
         (g_lastAppliedTP <= 0.0 || MathAbs(curTP - g_lastAppliedTP) > tol))
        {
         if(candTP <= 0.0)                          candTP = curTP;
         else if(MathAbs(curTP - candTP) > tol)     tpConflict = true;
        }
      if(!g_state.trailingActive && baseSL > 0.0 && curSL > tol && MathAbs(curSL - baseSL) > tol &&
         (g_lastAppliedSL <= 0.0 || MathAbs(curSL - g_lastAppliedSL) > tol))
        {
         if(candSL <= 0.0)                          candSL = curSL;
         else if(MathAbs(curSL - candSL) > tol)     slConflict = true;
        }
     }
   if(tpConflict || slConflict)
     {
      string reverted = "";
      if(tpConflict) reverted += "TP " + DoubleToString(baseTP, _Digits);
      if(slConflict) reverted += (tpConflict ? " and " : "") + "SL " + DoubleToString(baseSL, _Digits);
      Log(LOG_WARN, StringFormat("Conflicting manual %s edits in one pass - NONE adopted, all reverted to %s. Edit ONE ticket only; the value propagates to the whole sequence (M4-1).",
                                 (tpConflict && slConflict) ? "TP and SL" : (tpConflict ? "TP" : "SL"), reverted));
     }

   bool saved = false;
   if(candTP > 0.0 && !tpConflict)
     {
      if(dir * (candTP - baseTP) > tol)
         Log(LOG_WARN, StringFormat("Manual TP %s ADOPTED (was %s) - RISK: target moved %d pts farther from price; the sequence must run further before banking (trader's responsibility)",
                                    DoubleToString(candTP, _Digits), DoubleToString(baseTP, _Digits),
                                    (int)MathRound(MathAbs(candTP - baseTP) / _Point)));
      else
         Log(LOG_INFO, StringFormat("Manual TP %s ADOPTED (was %s) - propagating to all %d position(s); releases on level add/close or trail-arm",
                                    DoubleToString(candTP, _Digits), DoubleToString(baseTP, _Digits), g_state.levelCount));
      g_state.manualTP = candTP;
      saved = true;
     }
   if(candSL > 0.0 && !slConflict)
     {
      if(g_state.beApplied && dir * (candSL - BEStopPrice()) <= tol)
         Log(LOG_WARN, StringFormat("Manual SL %s REFUSED - at/below BE floor %s (engines own once armed; the floor never lowers - M6-2). Reverting.",
                                    DoubleToString(candSL, _Digits), DoubleToString(BEStopPrice(), _Digits)));
      else
        {
         if(dir * (baseSL - candSL) > tol)
           {
            double extraLoss = (tickSize > 0.0 ? MathAbs(baseSL - candSL) / tickSize * tickVal * totalLots : 0.0);
            Log(LOG_WARN, StringFormat("Manual SL %s ADOPTED (was %s) - RISK: max loss widened ~%.2f %s (+%d pts on %.2f lots); more recovery levels can open before the stop (trader's responsibility). Persists across level adds.",
                                       DoubleToString(candSL, _Digits), DoubleToString(baseSL, _Digits),
                                       extraLoss, AccountInfoString(ACCOUNT_CURRENCY),
                                       (int)MathRound(MathAbs(baseSL - candSL) / _Point), totalLots));
           }
         else
            Log(LOG_INFO, StringFormat("Manual SL %s ADOPTED (was %s) - tighter; note it also caps recovery depth (level budget). Persists across level adds.",
                                       DoubleToString(candSL, _Digits), DoubleToString(baseSL, _Digits)));
         g_state.manualSL = candSL;
         saved = true;
        }
     }
   if(saved)
      StateSave(g_state);   // 14th save site: adoption is transition-current (D7)
  }

void EnforceExits()
  {
   if(g_state.levelCount == 0)
      return;
   if(g_nextModifyTry > 0 && TimeCurrent() < g_nextModifyTry)
      return;   // backoff window after a failure

   double tp, sl;
   ComputeTargets(tp, sl);
   DetectManualExitEdits(tp, sl);    // Stage 8 (b24): classify broker-side deltas (adopt/refuse/conflict)
   if(g_state.manualTP > 0.0 && !g_state.trailingActive)
      tp = g_state.manualTP;         // b24: owned TP substitutes as the want-value (matrix D4)
   if(g_state.manualSL > 0.0)
      sl = g_state.manualSL;         // b24: owned SL substitutes; engines may still tighten on top
   ApplyProtectiveEngines(tp, sl);   // Stage 6: BE/trail merge (may zero tp, tighten sl)
   if(g_prevAnchorLvl > 0 && g_curAnchorLvl != g_prevAnchorLvl && sl > 0.0 && g_state.manualSL <= 0.0)
      Log(LOG_INFO, StringFormat("SL re-anchored: L%d -> L%d (widened to %s per locked rule - boundaries move with the structure)",
                                 g_prevAnchorLvl, g_curAnchorLvl, DoubleToString(sl, _Digits)));
   g_prevAnchorLvl = g_curAnchorLvl;
   if(tp == 0.0 && sl == 0.0)
      return;   // nothing managed (S8: no TP configured, no SL configured)

   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tol      = (tickSize > 0.0 ? tickSize : _Point) / 2.0;
   double bid      = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask      = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   long   stopsPts = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   long   freezePts= SymbolInfoInteger(_Symbol, SYMBOL_TRADE_FREEZE_LEVEL);
   double minDist  = MathMax((double)stopsPts, (double)freezePts) * _Point;
   int    dir      = g_state.direction;

   // TP already exceeded by price (locked decision, Stage4-b3): TP is a
   // minimum acceptable exit. Price at/beyond the computed target = target
   // fulfilled -> close the whole sequence at market, banking >= target.
   // Covers both the post-level-close recompute (observed in R8) and the
   // Stage 3 known edge (adoption already beyond Initial TP).
   if(tp > 0.0)
     {
      bool exceeded = (dir > 0) ? (bid >= tp) : (ask <= tp);
      // b20 TP-race gate (found live in S6-6): if every tracked position
      // already carries the computed TP broker-side, the broker's own fill
      // wins this race by construction - a market close here is redundant
      // and bounces with 10036. The rule stands down; it exists for exits
      // the broker does NOT hold (post-close recompute, adoption beyond
      // target, deferred placement).
      if(exceeded)
        {
         bool brokerHoldsTP = true;
         for(int i = 0; i < g_state.levelCount; i++)
           {
            if(!PositionSelectByTicket(g_state.tickets[i]))
               continue;
            if(MathAbs(PositionGetDouble(POSITION_TP) - tp) > tol)
              { brokerHoldsTP = false; break; }
           }
         if(!brokerHoldsTP)
           {
            CloseSequenceAtMarket(StringFormat("%s TP %s already exceeded by market (%s)",
                                               (g_state.manualTP > 0.0 && MathAbs(tp - g_state.manualTP) <= tol)
                                                  ? "manual (trader target)" : "computed",
                                               DoubleToString(tp, _Digits),
                                               DoubleToString(dir > 0 ? bid : ask, _Digits)));
            return;   // liveness cleans up state on the next pass
           }
         // else: broker TP is live everywhere - let it fill (liveness will
         // attribute it as a TP hit). No log: this is the normal exit path.
        }
     }

   // SL already exceeded by price (locked decision, Stage4-b5, symmetric
   // twin of the TP rule above): SL is a MAXIMUM acceptable loss. Price
   // at/beyond the computed stop = loss cap breached -> close the whole
   // sequence at market, capping the loss now instead of deferring an
   // unplaceable SL and hoping for a retrace. Covers the restart-gap case
   // (price gapped past a re-anchored SL while offline) and adoption of a
   // trade already beyond its computed SL (closed immediately - the loss-
   // side twin of the instant TP bank).
   if(sl > 0.0)
     {
      bool slExceeded = (dir > 0) ? (bid <= sl) : (ask >= sl);
      if(slExceeded)
        {
         // b20: symmetric race gate (see TP above).
         bool brokerHoldsSL = true;
         for(int i = 0; i < g_state.levelCount; i++)
           {
            if(!PositionSelectByTicket(g_state.tickets[i]))
               continue;
            if(MathAbs(PositionGetDouble(POSITION_SL) - sl) > tol)
              { brokerHoldsSL = false; break; }
           }
         if(!brokerHoldsSL)
           {
            CloseSequenceAtMarket(StringFormat("%s SL %s already exceeded by market (%s) - SL is a maximum acceptable loss",
                                               (g_state.manualSL > 0.0 && MathAbs(sl - g_state.manualSL) <= tol)
                                                  ? "manual (trader risk cap)"
                                                  : (g_state.trailingActive ? "trail ratchet"
                                                     : ((g_state.beApplied && MathAbs(sl - BEStopPrice()) <= tol) ? "BE floor" : "computed")),
                                               DoubleToString(sl, _Digits),
                                               DoubleToString(dir > 0 ? bid : ask, _Digits)));
            return;   // liveness cleans up state on the next pass
           }
        }
     }

   // Broker-constraint gate on the DESIRED values (S5): a target too close
   // to price (inside stops/freeze distance) is deferred, not fired-to-fail.
   bool tpPlaceable = (tp > 0.0);
   bool slPlaceable = (sl > 0.0);
   if(tp > 0.0)
     {
      if(dir > 0 && (tp - bid) < minDist) tpPlaceable = false;
      if(dir < 0 && (ask - tp) < minDist) tpPlaceable = false;
     }
   if(sl > 0.0)
     {
      if(dir > 0 && (bid - sl) < minDist) slPlaceable = false;
      if(dir < 0 && (sl - ask) < minDist) slPlaceable = false;
     }
   // b21 cosmetic: only WARN about a deferral if some tracked position
   // actually lacks the wanted value - the broker already holding it
   // everywhere means nothing is being deferred (seen 3x in Stage 6 runs).
   bool tpNeeded = false, slNeeded = false;
   if((tp > 0.0 && !tpPlaceable) || (sl > 0.0 && !slPlaceable))
     {
      for(int i = 0; i < g_state.levelCount; i++)
        {
         if(!PositionSelectByTicket(g_state.tickets[i]))
            continue;
         if(tp > 0.0 && !tpPlaceable && MathAbs(PositionGetDouble(POSITION_TP) - tp) > tol) tpNeeded = true;
         if(sl > 0.0 && !slPlaceable && MathAbs(PositionGetDouble(POSITION_SL) - sl) > tol) slNeeded = true;
         if(tpNeeded && slNeeded) break;
        }
     }
   if((tpNeeded || slNeeded) && TimeCurrent() - g_lastDeferLog >= 60)
     {
      g_lastDeferLog = TimeCurrent();
      Log(LOG_WARN, StringFormat("EnforceExits: %s%s%s inside broker min stop distance %s - deferred, retrying each tick",
                                 tpNeeded ? "TP" : "",
                                 (tpNeeded && slNeeded) ? " and " : "",
                                 slNeeded ? "SL" : "",
                                 DoubleToString(minDist, _Digits)));
     }

   bool anyApplied = true;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      ulong ticket = g_state.tickets[i];
      if(!PositionSelectByTicket(ticket))
         continue;
      double curTP = PositionGetDouble(POSITION_TP);
      double curSL = PositionGetDouble(POSITION_SL);
      double wantTP = g_state.trailingActive ? 0.0
                      : ((tp > 0.0 && tpPlaceable) ? tp : curTP);
      double wantSL = (sl > 0.0 && slPlaceable) ? sl : curSL;
      if(g_state.trailingActive && curTP > 0.0 && g_lastAppliedTP == 0.0)
         Log(LOG_WARN, StringFormat("TP %s found on ticket %I64u while trailing owns the exit - REMOVED (manual TP re-add; trailing replaced the TP at activation)",
                                    DoubleToString(curTP, _Digits), ticket));
      if(MathAbs(curTP - wantTP) <= tol && MathAbs(curSL - wantSL) <= tol)
         continue;   // idempotence: nothing to do for this position

      // Manual-change detection (S3/S4): only for tickets the EA has already
      // dressed at least once. A fresh recovery position arrives with 0/0
      // exits - that is initial placement, not a user edit (b2 fix: the
      // sequence-level lastApplied produced false manual-change WARNs).
      bool armed = HasAppliedExits(ticket);
      // b24: non-zero edits are classified (adopted/refused) by
      // DetectManualExitEdits before this loop; the only WARN owned here is
      // REMOVAL - stripping is never adopted (matrix D3/M1). Refused edits
      // (post-arm looser SL, conflicts) revert silently here: detection
      // already logged the classification WARN this pass.
      if(armed && g_lastAppliedTP > 0.0 && wantTP > 0.0 && curTP <= tol)
         Log(LOG_WARN, StringFormat("Manual TP REMOVAL on ticket %I64u - reverted to %s (removals are never adopted; deliberate no-TP belongs in config)",
                                    ticket, DoubleToString(wantTP, _Digits)));
      if(armed && g_lastAppliedSL > 0.0 && wantSL > 0.0 && curSL <= tol)
         Log(LOG_WARN, StringFormat("Manual SL REMOVAL on ticket %I64u - reverted to %s (removals are never adopted; a sequence never runs uncapped)",
                                    ticket, DoubleToString(wantSL, _Digits)));

      if(!g_trade.PositionModify(ticket, wantSL, wantTP))
        {
         anyApplied = false;
         g_modifyFails++;
         g_nextModifyTry = TimeCurrent() + 5;   // backoff: retry in 5s
         Log(LOG_ERROR, StringFormat("PositionModify FAILED on ticket %I64u (retcode %d: %s) - fail #%d, retrying in 5s",
                                     ticket, (int)g_trade.ResultRetcode(), g_trade.ResultRetcodeDescription(), g_modifyFails));
         if(g_modifyFails >= 10 && !g_modifyAlerted)
           {
            g_modifyAlerted = true;
            Alert(StringFormat("TRTM %s: exit modification failing repeatedly (%d consecutive) - check terminal/broker!", g_symbolNorm, g_modifyFails));
           }
         continue;
        }
      MarkExitsApplied(ticket);
      Log(LOG_INFO, StringFormat("Exits applied to ticket %I64u: TP %s SL %s%s",
                                 ticket,
                                 wantTP > 0.0 ? DoubleToString(wantTP, _Digits) : "none",
                                 wantSL > 0.0 ? DoubleToString(wantSL, _Digits) : "none",
                                 (g_lastAppliedTP == 0.0 && g_lastAppliedSL == 0.0 &&
                                  ((curTP > 0.0 && MathAbs(curTP - wantTP) > tol) ||
                                   (curSL > 0.0 && MathAbs(curSL - wantSL) > tol)))
                                 ? StringFormat(" (replaced user-set TP %s SL %s)",
                                                curTP > 0.0 ? DoubleToString(curTP, _Digits) : "none",
                                                curSL > 0.0 ? DoubleToString(curSL, _Digits) : "none")
                                 : ""));
     }

   if(anyApplied)
     {
      if(g_modifyFails > 0)
         Log(LOG_INFO, StringFormat("Exit modification recovered after %d failure(s)", g_modifyFails));
      g_modifyFails   = 0;
      g_nextModifyTry = 0;
      g_modifyAlerted = false;
      if(tpPlaceable && tp > 0.0) g_lastAppliedTP = tp;
      if(slPlaceable && sl > 0.0) g_lastAppliedSL = sl;
      if(g_state.trailingActive)  g_lastAppliedTP = 0.0;   // TP is structurally gone past activation
     }
  }

//+------------------------------------------------------------------+
//| RECOVERY ENGINE (Stage 4)                                        |
//| Opens level N+1 when price moves Recovery Interval points beyond |
//| the worst surviving entry, confirmed by bar close on the set TF  |
//| (spike protection) or by touch when Bar Close Entry is off.      |
//| Locked rules: intervals from actual entries (never a fixed grid),|
//| never retroactive (bar must CLOSE after the gate time), forfeit  |
//| on filter block (bar-close mode consumes the signal), ONE level  |
//| per bar close maximum.                                           |
//+------------------------------------------------------------------+
datetime g_lastRecoveryBar = 0;   // one evaluation per recovery-TF bar
double   g_manualMult[];          // parsed Manual Multiplier list

bool ParseManualMultipliers()
  {
   ArrayResize(g_manualMult, 0);
   string parts[];
   int n = StringSplit(InpManualMultipliers, ',', parts);
   for(int i = 0; i < n; i++)
     {
      StringTrimLeft(parts[i]);
      StringTrimRight(parts[i]);
      double m = StringToDouble(parts[i]);
      if(m <= 0.0)
        {
         Log(LOG_ERROR, StringFormat("Manual Multiplier entry %d ('%s') is not a positive number", i + 1, parts[i]));
         ArrayResize(g_manualMult, 0);   // b17: no partial list may survive a failed parse
         return false;
        }
      int sz = ArraySize(g_manualMult);
      if(sz > 0 && m < 1.0)
        {
         Log(LOG_ERROR, StringFormat("Manual Multiplier entry %d (%.2f) is < 1.00 - recovery levels scale from the L1 base, so every multiplier below 1 sizes BELOW the base (Guard C geometry)", i + 1, m));
         ArrayResize(g_manualMult, 0);
         return false;
        }
      if(sz > 0 && m < g_manualMult[sz - 1])
        {
         Log(LOG_ERROR, StringFormat("Manual Multipliers must be non-decreasing: entry %d (%.2f) < entry %d (%.2f) - equal or increasing only (locked, Guard C geometry)",
                                     i + 1, m, i, g_manualMult[sz - 1]));
         ArrayResize(g_manualMult, 0);   // b17: no partial list may survive a failed parse
         return false;
        }
      ArrayResize(g_manualMult, sz + 1);
      g_manualMult[sz] = m;
     }
   return ArraySize(g_manualMult) > 0;
  }

// Lot for level N (N >= 2), derived from the sequence base lot (L1's
// original volume - survives L1 closing). Normalized to the symbol's
// volume constraints; every adjustment is logged.
double ComputeLevelLot(const int levelN)
  {
   double base = g_state.baseLot;
   if(base <= 0.0)
     {
      Log(LOG_ERROR, "ComputeLevelLot: base lot unknown (<=0) - recovery entry aborted");
      return 0.0;
     }
   double lot = 0.0;
   switch(InpRecoveryMultMode)
     {
      case RM_INCREMENTAL:
         lot = base + (levelN - 1) * InpIncrementStep;
         break;
      case RM_FIXED:
         lot = InpFixedRecoveryLot;
         break;
      case RM_MARTINGALE:
         lot = base * MathPow(InpMartingaleMult, levelN - 1);
         break;
      case RM_DEFERRED_INCREMENTAL:
         lot = base + MathFloor((levelN - 1) / (double)InpDeferredStep) * InpIncrementStep;
         break;
      case RM_DEFERRED_MARTINGALE:
         lot = base * MathPow(InpMartingaleMult, MathFloor((levelN - 1) / (double)InpDeferredStep));
         break;
      case RM_MANUAL:
        {
         int idx = levelN - 1;
         int last = ArraySize(g_manualMult) - 1;
         if(idx > last)
           {
            if(!AlreadyLogged("mclamp:" + (string)levelN))
               Log(LOG_WARN, StringFormat("Manual Multiplier list has %d entries - level %d clamped to last multiplier %.2f", last + 1, levelN, g_manualMult[last]));
            idx = last;
           }
         lot = base * g_manualMult[idx];
         break;
        }
     }
   // Broker volume constraints
   double step   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double volMin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double volMax = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double raw = lot;
   if(step > 0.0)
      lot = MathRound(lot / step) * step;
   lot = MathMax(volMin, MathMin(volMax, lot));
   lot = NormalizeDouble(lot, 8);
   if(MathAbs(lot - raw) > 0.0000001)
      Log(LOG_WARN, StringFormat("Level %d lot %.4f normalized to %.4f (step %.4f, min %.2f, max %.2f)", levelN, raw, lot, step, volMin, volMax));
   return lot;
  }

// Registers a freshly opened recovery position into the sequence by
// rescanning for our magic + the expected level comment.
bool RegisterNewRecovery(const int levelN)
  {
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != g_magic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(ParseLevelFromComment(PositionGetString(POSITION_COMMENT)) != levelN) continue;
      bool tracked = false;
      for(int j = 0; j < g_state.levelCount; j++)
         if(g_state.tickets[j] == ticket) { tracked = true; break; }
      if(tracked) continue;
      if(g_state.levelCount >= TRTM_MAX_LEVELS)
        {
         Log(LOG_ERROR, "RegisterNewRecovery: TRTM_MAX_LEVELS reached - position opened but NOT tracked. Manual review required.");
         return false;
        }
      g_state.tickets[g_state.levelCount] = ticket;
      g_state.levels[g_state.levelCount]  = levelN;
      g_state.levelCount++;
      ReleaseManualTP(StringFormat("level add (L%d)", levelN));   // b24; manual SL untouched (M3-4)
      StateSave(g_state);
      Log(LOG_INFO, StringFormat("Recovery L%d registered: ticket %I64u", levelN, ticket));
      LogStructure();
      return true;
     }
   Log(LOG_ERROR, StringFormat("RegisterNewRecovery: L%d order reported filled but position not found - manual review required", levelN));
   return false;
  }

// Projection math shared by LogStructure (Stage 4) and the dashboard
// (Stage 5). Extracted in b9 as a pure lift-out - identical arithmetic -
// so the panel displays the SAME computation the engine logs, never a
// display-only mirror that can drift. Also returns simple avg entry
// (the sequence TP anchor) for the dashboard's live row.
void ComputeProjection(const double tp, const double sl,
                       double &lots, double &pTP, double &pSL, double &avgEntry)
  {
   double tickVal = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSz  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSz <= 0.0) tickSz = _Point;
   int dir = g_state.direction;
   lots = 0.0; pTP = 0.0; pSL = 0.0; avgEntry = 0.0;
   double sumPrice = 0.0;
   int    counted  = 0;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      if(!PositionSelectByTicket(g_state.tickets[i]))
         continue;
      double vol   = PositionGetDouble(POSITION_VOLUME);
      double entry = PositionGetDouble(POSITION_PRICE_OPEN);
      lots += vol;
      sumPrice += entry;
      counted++;
      if(tp > 0.0) pTP += dir * (tp - entry) / tickSz * tickVal * vol;
      if(sl > 0.0) pSL += dir * (sl - entry) / tickSz * tickVal * vol;
     }
   if(counted > 0)
      avgEntry = sumPrice / counted;
  }

// Structure summary + projected PnL guard. Called on every structure
// change (adoption, level open, level removal).
void LogStructure()
  {
   if(g_state.levelCount == 0)
      return;
   double tp, sl;
   ComputeTargets(tp, sl);
   if(g_state.manualTP > 0.0 && !g_state.trailingActive)
      tp = g_state.manualTP;   // b26: projection reflects the value actually in charge
   if(g_state.manualSL > 0.0)
      sl = g_state.manualSL;
   double lots, pTP, pSL, avgEntry;
   ComputeProjection(tp, sl, lots, pTP, pSL, avgEntry);
   Log(LOG_INFO, StringFormat("Structure: %d level(s), %.2f lots | projected at TP %s | at SL %s",
                              g_state.levelCount, lots,
                              tp > 0.0 ? StringFormat("%+.2f", pTP) : "n/a",
                              sl > 0.0 ? StringFormat("%+.2f", pSL) : "n/a"));
   if(tp > 0.0 && pTP <= 0.0)
      Log(LOG_WARN, StringFormat("TP GUARD: projected PnL at TP is %+.2f (<= 0). Current multiplier structure exits at a LOSS at TP. Review recovery lot sizing relative to L1 volume.", pTP));
  }

// Next-level number, worst surviving entry, trigger price, and gate time.
// Extracted in b9 as a pure lift-out from EvaluateRecovery so the Stage 5
// dashboard's next-trigger row displays the SAME math the engine fires on.
// Returns false when there is nothing to compute (no sequence / no live
// entries). Max-level cap is NOT checked here - the engine checks it (and
// logs), the dashboard checks it (and displays).
bool ComputeRecoveryTrigger(int &nextLvl, double &trigger, double &worst, datetime &gateTime)
  {
   if(g_state.levelCount == 0 || g_state.direction == 0)
      return false;
   int dir = g_state.direction;

   // Next level number = highest tracked level + 1 (levels are monotonic;
   // gaps from manual closes do not reuse numbers).
   int maxLvl = 0;
   for(int i = 0; i < g_state.levelCount; i++)
      if(g_state.levels[i] > maxLvl) maxLvl = g_state.levels[i];
   nextLvl = maxLvl + 1;

   // Worst surviving entry + gate time (no-retroactive rule)
   worst    = 0.0;
   gateTime = g_state.adoptionTime;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      if(!PositionSelectByTicket(g_state.tickets[i]))
         continue;
      double   entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      datetime opened = (datetime)PositionGetInteger(POSITION_TIME);
      if(worst == 0.0 || (dir < 0 && entry > worst) || (dir > 0 && entry < worst))
         worst = entry;
      if(opened > gateTime)
         gateTime = opened;
     }
   if(worst == 0.0)
      return false;
   trigger = (dir < 0) ? worst + InpRecoveryIntervalPts * _Point
                       : worst - InpRecoveryIntervalPts * _Point;
   return true;
  }

// Main recovery evaluation, called every tick while a sequence is active.
void EvaluateRecovery()
  {
   if(!InpEnableRecovery || g_state.levelCount == 0 || g_state.direction == 0)
      return;
   if(g_state.trailingActive)
      return;   // Stage 6: no new levels once trailing has taken over

   int dir = g_state.direction;

   int      nextLvl  = 0;
   double   trigger  = 0.0;
   double   worst    = 0.0;
   datetime gateTime = 0;
   if(!ComputeRecoveryTrigger(nextLvl, trigger, worst, gateTime))
      return;

   // RA2 note (b16): the max-levels cap is checked AFTER ComputeRecoveryTrigger
   // on purpose - the trigger math is needed to know WHICH level would be next,
   // and the dashboard Next row reuses the same ordering. Cap first would save
   // nothing (the compute is cheap) and desync the two call sites.
   if(InpMaxRecoveryTrades > 0 && (nextLvl - 1) > InpMaxRecoveryTrades)
     {
      if(!AlreadyLogged("maxlvl:" + (string)(long)g_state.adoptionTime))
         Log(LOG_WARN, StringFormat("Max Recovery Trades (%d) reached - no further levels will be opened this sequence. Exits remain enforced.", InpMaxRecoveryTrades));
      return;
     }

   // Signal
   if(InpBarCloseEntry)
     {
      datetime curBar = iTime(_Symbol, InpRecoveryTF, 0);
      if(curBar == g_lastRecoveryBar)
         return;                    // this bar already evaluated (forfeit rule)
      g_lastRecoveryBar = curBar;   // consume the bar NOW - blocked entries forfeit
      if(curBar <= gateTime)
         return;                    // closed bar predates the gate: not fresh info
      double closePx = iClose(_Symbol, InpRecoveryTF, 1);
      bool signal = (dir < 0) ? (closePx >= trigger) : (closePx <= trigger);
      if(!signal)
         return;
      Log(LOG_INFO, StringFormat("Recovery signal: %s bar closed %s vs trigger %s (worst entry %s %s %d pts)",
                                 EnumToString(InpRecoveryTF), DoubleToString(closePx, _Digits),
                                 DoubleToString(trigger, _Digits), DoubleToString(worst, _Digits),
                                 dir < 0 ? "+" : "-", InpRecoveryIntervalPts));
     }
   else
     {
      double px = (dir < 0) ? SymbolInfoDouble(_Symbol, SYMBOL_BID)
                            : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      bool signal = (dir < 0) ? (px >= trigger) : (px <= trigger);
      if(!signal)
         return;
     }

   // Entry-side guard (b2): the signal may be bid-based (bar closes), but a
   // BUY fills at ask. The interval is a MINIMUM DISTANCE BETWEEN ENTRIES,
   // so the prospective fill price itself must satisfy the trigger. Without
   // this, spread >> interval stacks levels on top of each other (observed
   // on weekend BTCUST: L4 filled ABOVE L3's entry).
   double entrySidePx = (dir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                                  : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   bool fillOk = (dir < 0) ? (entrySidePx >= trigger) : (entrySidePx <= trigger);
   if(!fillOk)
     {
      Log(LOG_WARN, StringFormat("Recovery L%d FORFEITED: fill-side price %s does not satisfy trigger %s (spread pushes entry inside the interval). Interval is a minimum entry distance - next qualifying %s awaited.",
                                 nextLvl, DoubleToString(entrySidePx, _Digits), DoubleToString(trigger, _Digits),
                                 InpBarCloseEntry ? "bar close" : "touch"));
      return;
     }

   // Spread filter (recovery entries only - locked rule)
   if(InpSpreadFilter)
     {
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double spreadPts = (ask - bid) / _Point;
      if(spreadPts > InpMaxSpreadPts)
        {
         Log(LOG_WARN, StringFormat("Recovery L%d FORFEITED: spread %.0f pts > max %d pts. Next qualifying %s awaited.",
                                    nextLvl, spreadPts, InpMaxSpreadPts,
                                    InpBarCloseEntry ? "bar close" : "touch"));
         return;
        }
     }

   double lot = ComputeLevelLot(nextLvl);
   if(lot <= 0.0)
      return;

   // Guard C (b16, locked): recovery lots must be NON-DECREASING - equal or
   // increasing only. Declining lots invert the breakeven geometry that the
   // structural BE relies on (big lot at the worst price pulls true breakeven
   // beyond avg + offset). Init validation catches static configs; this
   // runtime check covers what init cannot see (Fixed lot < live base, list
   // clamping edges). Refuse, never resize.
   double prevVol = 0.0;
   int    prevLvl = 0;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      if(g_state.levels[i] > prevLvl && PositionSelectByTicket(g_state.tickets[i]))
        {
         prevLvl = g_state.levels[i];
         prevVol = PositionGetDouble(POSITION_VOLUME);
        }
     }
   if(prevVol > 0.0 && lot < prevVol - 0.0000001)
     {
      if(!AlreadyLogged("guardc:" + (string)(long)g_state.adoptionTime))
        {
         Log(LOG_WARN, StringFormat("Recovery L%d REFUSED: lot %.2f < L%d lot %.2f - recovery lots must be non-decreasing (Guard C). Exits remain enforced.",
                                    nextLvl, lot, prevLvl, prevVol));
         NotifyMobile(StringFormat("recovery BLOCKED (Guard C): L%d lot %.2f < L%d lot %.2f. TP/SL still enforced. Fix the recovery lot config.",
                                   nextLvl, lot, prevLvl, prevVol));   // b19: the away-user must know
        }
      g_dashWarn = StringFormat("recovery blocked: L%d lot < L%d (Guard C)", nextLvl, prevLvl);
      return;
     }

   string comment = g_symbolNorm;
   StringToLower(comment);
   comment += "_l" + (string)nextLvl + "_" + (dir > 0 ? "buy" : "sell");

   g_trade.SetExpertMagicNumber(g_magic);
   g_trade.SetDeviationInPoints(InpDeviationFilter ? (ulong)InpMaxDeviationPts : 1000000);
   double px = (dir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                         : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(!EntrySLRealizable(px))
      return;   // Guard B re-check at execution price, reason logged
   bool sent = g_trade.PositionOpen(_Symbol, dir > 0 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL,
                                    lot, px, 0.0, 0.0, comment);
   uint rc = g_trade.ResultRetcode();
   if(!sent || (rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_DONE_PARTIAL && rc != TRADE_RETCODE_PLACED))
     {
      Log(LOG_ERROR, StringFormat("Recovery L%d order FAILED (retcode %d: %s) - signal forfeited, next qualifying signal awaited",
                                  nextLvl, rc, g_trade.ResultRetcodeDescription()));
      return;
     }
   Log(LOG_INFO, StringFormat("Recovery L%d OPENED: %.2f lots %s @ %s (deal %I64u)",
                              nextLvl, lot, dir > 0 ? "BUY" : "SELL",
                              DoubleToString(g_trade.ResultPrice(), _Digits), g_trade.ResultDeal()));
   RegisterNewRecovery(nextLvl);
  }

//+------------------------------------------------------------------+
//| RECONCILIATION                                                   |
//| Terminal is truth, file is annotation.                           |
//| Stage 1 scope: rescan live positions by magic, parse _lN_ level  |
//| from comments, rebuild the live map, and compare against the     |
//| loaded file. Discrepancies are logged, live map wins. The        |
//| non-reconstructable flags are taken from the file ONLY when the  |
//| sequence is still alive at the broker.                           |
//+------------------------------------------------------------------+
int ParseLevelFromComment(const string comment)
  {
   // expected pattern fragment: "_l<N>_"  (e.g. xauusd_l3_sell)
   string c = comment;
   StringToLower(c);
   int p = StringFind(c, "_l");
   while(p >= 0)
     {
      int q = StringFind(c, "_", p + 2);
      if(q > p + 2)
        {
         string numPart = StringSubstr(c, p + 2, q - (p + 2));
         bool numeric = StringLen(numPart) > 0;
         for(int i = 0; i < StringLen(numPart) && numeric; i++)
           {
            ushort ch = StringGetCharacter(numPart, i);
            if(ch < '0' || ch > '9') numeric = false;
           }
         if(numeric)
            return (int)StringToInteger(numPart);
        }
      p = StringFind(c, "_l", p + 2);
     }
   return -1;
  }

void RebuildLiveMap(SequenceState &live)
  {
   StateReset(live);
   int total = PositionsTotal();
   for(int i = 0; i < total; i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
        {
         Log(LOG_WARN, StringFormat("RebuildLiveMap: PositionGetTicket(%d) returned 0 - position skipped", i));
         continue;
        }
      if(PositionGetInteger(POSITION_MAGIC) != g_magic)
         continue;
      if(NormalizeSymbol(PositionGetString(POSITION_SYMBOL)) != g_symbolNorm)
         continue;

      string comment = PositionGetString(POSITION_COMMENT);
      int lvl = ParseLevelFromComment(comment);
      if(lvl < 0)
        {
         Log(LOG_WARN, StringFormat("RebuildLiveMap: position %I64u has our magic but unparseable level comment '%s' - counted, level unknown", ticket, comment));
         lvl = 0;
        }
      if(live.levelCount >= TRTM_MAX_LEVELS)
        {
         Log(LOG_ERROR, "RebuildLiveMap: TRTM_MAX_LEVELS exceeded - further positions ignored in map");
         break;
        }
      live.tickets[live.levelCount] = ticket;
      live.levels[live.levelCount]  = lvl;
      live.levelCount++;

      long type = PositionGetInteger(POSITION_TYPE);
      int dir = (type == POSITION_TYPE_BUY) ? 1 : -1;
      if(live.direction == 0)
         live.direction = dir;
      else if(live.direction != dir)
         Log(LOG_ERROR, StringFormat("RebuildLiveMap: mixed directions under magic %d - position %I64u conflicts. Manual review required.", (int)g_magic, ticket));
     }
   // NOTE (b2): the former pass-2 tag scan is gone. Grafting an L1 into the
   // map by tag alone could adopt a foreign position into a live sequence
   // (corrupting avg entry / TP / SL anchoring). Adopted-L1 restore is now
   // state-file-first and lives in Reconcile().
  }

//+------------------------------------------------------------------+
//| STAGE 8 (b24): RECONCILE MANUAL OWNERSHIP (matrix M7)            |
//| Called at the end of Reconcile's live-sequence path. Composes    |
//| D2 + D6 over the death window:                                   |
//|  - persisted ticket missing -> structural event -> TP releases,  |
//|    SL ownership CONTINUES (M7-4)                                 |
//|  - broker uniform value != computed & != persisted -> trader     |
//|    edited while EA dead -> fresh adoption (M7-5)                 |
//|  - mixed SL where some match persisted manual -> kill landed mid |
//|    -propagation -> keep ownership, first pass completes (M7-7)   |
//|  - mixed values matching nothing -> conflict -> computed wins    |
//|    with WARN (M7-6)                                              |
//| Seeds lastApplied/armed so steady-state detection resumes with a |
//| clean baseline; sets the one-pass detection skip.                |
//+------------------------------------------------------------------+
void ReconcileManualExits(const SequenceState &file, const bool haveFile)
  {
   if(g_state.levelCount == 0)
      return;
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tol      = (tickSize > 0.0 ? tickSize : _Point) / 2.0;
   int    dir      = g_state.direction;

   if(g_state.trailingActive && g_state.manualTP > 0.0)
     {
      Log(LOG_INFO, "Reconcile: persisted manual TP dropped - trailing owns the exit (TP is structurally gone past activation)");
      g_state.manualTP = 0.0;
     }
   // Death-window structural event: a persisted ticket no longer lives.
   // b28 (M7-8): remember the value being released - survivors still
   // carry it at the broker (the EA's OWN pre-kill propagation) and the
   // M7-5 branch below must not re-adopt it as a trader edit (the
   // reconcile-path analogue of the b25/M5-6 discriminator).
   double releasedTP = 0.0;
   if(haveFile && g_state.manualTP > 0.0 && file.levelCount > 0)
      for(int i = 0; i < file.levelCount; i++)
        {
         bool found = false;
         for(int j = 0; j < g_state.levelCount; j++)
            if(g_state.tickets[j] == file.tickets[i]) { found = true; break; }
         if(!found)
           {
            releasedTP = g_state.manualTP;
            ReleaseManualTP(StringFormat("position closed while EA was offline (ticket %I64u - death-window structural event)", file.tickets[i]));
            break;
           }
        }

   double compTP = 0.0, compSL = 0.0;
   ComputeTargets(compTP, compSL);

   // Uniformity scan of live broker values.
   double uTP = 0.0, uSL = 0.0;
   bool   tpUni = true, slUni = true;
   int    seen = 0, slMatchManual = 0;
   string staleList = "";
   for(int i = 0; i < g_state.levelCount; i++)
     {
      if(!PositionSelectByTicket(g_state.tickets[i]))
         continue;
      double curTP = PositionGetDouble(POSITION_TP);
      double curSL = PositionGetDouble(POSITION_SL);
      seen++;
      if(seen == 1) { uTP = curTP; uSL = curSL; }
      else
        {
         if(MathAbs(curTP - uTP) > tol) tpUni = false;
         if(MathAbs(curSL - uSL) > tol) slUni = false;
        }
      if(g_state.manualSL > 0.0)
        {
         if(MathAbs(curSL - g_state.manualSL) <= tol)
            slMatchManual++;
         else
            staleList += (staleList == "" ? "#" : ", #") + (string)g_state.tickets[i];
        }
     }
   if(seen == 0)
      return;

   // --- TP classification (skip while trailing: no TP exists) ---
   if(!g_state.trailingActive)
     {
      if(g_state.manualTP > 0.0)
        {
         if(tpUni && MathAbs(uTP - g_state.manualTP) <= tol)
            Log(LOG_INFO, StringFormat("Reconcile: manual TP %s ownership continues across restart (broker agrees)", DoubleToString(g_state.manualTP, _Digits)));
         else if(tpUni && uTP > tol && MathAbs(uTP - compTP) > tol)
           {
            Log(LOG_INFO, StringFormat("Reconcile: manual TP re-edited to %s while EA was offline (was %s) - adopted", DoubleToString(uTP, _Digits), DoubleToString(g_state.manualTP, _Digits)));
            g_state.manualTP = uTP;
           }
         else if(!tpUni)
           {
            Log(LOG_WARN, "Reconcile: conflicting TP values found at broker after restart - manual ownership dropped, computed re-asserted (M7-6)");
            g_state.manualTP = 0.0;
           }
         else
           {
            Log(LOG_INFO, "Reconcile: broker TP matches computed - manual ownership released (reverted while EA was offline)");
            g_state.manualTP = 0.0;
           }
        }
      else if(tpUni && uTP > tol && compTP > 0.0 && MathAbs(uTP - compTP) > tol)
        {
         if(releasedTP > 0.0 && MathAbs(uTP - releasedTP) <= tol)
            // b28 (M7-8): survivors wear the value the death-window release
            // just dropped - that is the EA's own stale write awaiting
            // rewrite, NOT a trader edit. Same accepted nuance as M5-6: a
            // genuine dead-edit to exactly the old value is reverted once.
            Log(LOG_INFO, StringFormat("Reconcile: survivors carry the released manual TP %s - EA's own stale write, not a trader edit (M7-8); computed %s re-asserts", DoubleToString(uTP, _Digits), DoubleToString(compTP, _Digits)));
         else
           {
            Log(LOG_INFO, StringFormat("Reconcile: TP edited to %s while EA was offline (computed %s) - adopted as manual (M7-5)", DoubleToString(uTP, _Digits), DoubleToString(compTP, _Digits)));
            g_state.manualTP = uTP;
           }
        }
     }

   // --- SL classification (skip while trailing: ratchet floor logic owns it, b21) ---
   if(!g_state.trailingActive)
     {
      double beFloor = g_state.beApplied ? BEStopPrice() : 0.0;
      if(g_state.manualSL > 0.0)
        {
         if(slUni && MathAbs(uSL - g_state.manualSL) <= tol)
            Log(LOG_INFO, StringFormat("Reconcile: manual SL %s ownership continues across restart (broker agrees)", DoubleToString(g_state.manualSL, _Digits)));
         else if(!slUni && slMatchManual > 0)
            Log(LOG_WARN, StringFormat("Reconcile: manual SL propagation completed after restart - %s carried a stale SL during downtime (kill landed mid-propagation, M7-7)", staleList));
         else if(slUni && uSL > tol && MathAbs(uSL - compSL) > tol &&
                 (beFloor <= 0.0 || dir * (uSL - beFloor) > tol))
           {
            Log(LOG_INFO, StringFormat("Reconcile: manual SL re-edited to %s while EA was offline (was %s) - adopted", DoubleToString(uSL, _Digits), DoubleToString(g_state.manualSL, _Digits)));
            g_state.manualSL = uSL;
           }
         else if(!slUni)
           {
            Log(LOG_WARN, "Reconcile: conflicting SL values found at broker after restart, none matching persisted manual - ownership dropped, computed re-asserted (M7-6)");
            g_state.manualSL = 0.0;
           }
         else
           {
            Log(LOG_INFO, "Reconcile: broker SL matches computed - manual ownership released (reverted while EA was offline)");
            g_state.manualSL = 0.0;
           }
        }
      else if(slUni && uSL > tol && compSL > 0.0 && MathAbs(uSL - compSL) > tol &&
              (beFloor <= 0.0 || dir * (uSL - beFloor) > tol))
        {
         Log(LOG_INFO, StringFormat("Reconcile: SL edited to %s while EA was offline (computed %s) - adopted as manual (M7-5); persists across level adds", DoubleToString(uSL, _Digits), DoubleToString(compSL, _Digits)));
         g_state.manualSL = uSL;
        }
     }

   // Seed enforcement baseline: these ARE our own applied values (b21 note
   // on the ratchet floor stays consistent - the floor is our own SL).
   for(int i = 0; i < g_state.levelCount; i++)
      MarkExitsApplied(g_state.tickets[i]);
   if(g_state.manualTP > 0.0 && !g_state.trailingActive)
      g_lastAppliedTP = g_state.manualTP;
   if(g_state.manualSL > 0.0)
      g_lastAppliedSL = g_state.manualSL;
   g_manualDetectSkipOnce = true;
   StateSave(g_state);
  }

void Reconcile()
  {
   SequenceState live;
   RebuildLiveMap(live);            // magic-owned positions only (b2)

   SequenceState file;
   bool haveFile = StateLoad(file); // may be a live-sequence state OR a flat marker
   datetime lastClose = haveFile ? file.lastCloseTime : 0;

   // --- State-file-first restore of the adopted (magic 0) L1 ---
   if(haveFile && file.adoptedL1 && file.levelCount > 0)
     {
      ulong l1Ticket = 0;
      for(int i = 0; i < file.levelCount; i++)
         if(file.levels[i] == 1) { l1Ticket = file.tickets[i]; break; }

      if(l1Ticket > 0 && PositionSelectByTicket(l1Ticket) &&
         PositionGetString(POSITION_SYMBOL) == _Symbol)
        {
         int posDir = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 1 : -1;
         if(live.direction != 0 && live.direction != posDir)
            Log(LOG_ERROR, StringFormat("Reconcile: recorded L1 ticket %I64u direction conflicts with magic-level positions - L1 NOT restored. Manual review required.", l1Ticket));
         else if(live.levelCount < TRTM_MAX_LEVELS)
           {
            live.tickets[live.levelCount] = l1Ticket;
            live.levels[live.levelCount]  = 1;
            live.levelCount++;
            live.adoptedL1 = true;
            if(live.direction == 0)
               live.direction = posDir;
            Log(LOG_INFO, StringFormat("Reconcile: restored adopted L1 ticket %I64u from state file", l1Ticket));
           }
        }
      else if(l1Ticket > 0)
         Log(LOG_WARN, StringFormat("Reconcile: recorded adopted L1 ticket %I64u no longer exists - closed while EA was offline", l1Ticket));
     }

   if(live.levelCount == 0)
     {
      // Flat at the broker (any tagged magic-0 positions are handled by
      // the OnTick adoption scan, subject to the stale-tag gate).
      if(haveFile && file.levelCount > 0)
        {
         Log(LOG_WARN, StringFormat("Reconcile: file claims %d level(s) but broker is flat - sequence closed while EA was offline", file.levelCount));
         // Best available bound for the gate: the last moment the terminal
         // saw the sequence alive. Anything opened after that is fresh.
         if(lastClose < file.lastSaved)
            lastClose = file.lastSaved;
        }
      StateReset(g_state);
      g_state.lastCloseTime = lastClose;
      StateSave(g_state);   // persist flat marker
      Log(LOG_INFO, "Reconcile complete: FLAT");
      return;
     }

   // Live sequence exists: live map is the sequence, file supplies flags.
   g_state = live;
   g_state.lastCloseTime = lastClose;
   if(haveFile && file.levelCount > 0)
     {
      if(file.levelCount != live.levelCount)
         Log(LOG_WARN, StringFormat("Reconcile: level count file=%d vs broker=%d - broker wins", file.levelCount, live.levelCount));
      g_state.trailOverride  = file.trailOverride;
      g_state.beOverride     = file.beOverride;
      g_state.trailingActive = file.trailingActive;
      g_state.beApplied      = file.beApplied;
      g_state.adoptionTime   = file.adoptionTime;
      g_state.baseLot        = file.baseLot;
      g_state.manualTP       = file.manualTP;   // b24: refined by ReconcileManualExits below
      g_state.manualSL       = file.manualSL;
      Log(LOG_INFO, StringFormat("Reconcile: flags restored (trailOverride=%s beOverride=%s trailingActive=%s beApplied=%s)",
                                 g_state.trailOverride ? "T" : "F", g_state.beOverride ? "T" : "F",
                                 g_state.trailingActive ? "T" : "F", g_state.beApplied ? "T" : "F"));
     }
   else
     {
      // Live magic-owned positions but no usable file: flags lost. The EA
      // does NOT guess at grafting a tagged L1 into a live sequence - if
      // one belongs here, only the state file can prove it.
      g_state.adoptionTime = TimeCurrent();
      // baseLot lost with the file: derive from L1 if present, else the
      // smallest tracked volume (WARN - multiplier math may be off).
      for(int i = 0; i < g_state.levelCount; i++)
         if(g_state.levels[i] == 1 && PositionSelectByTicket(g_state.tickets[i]))
            g_state.baseLot = PositionGetDouble(POSITION_VOLUME);
      if(g_state.baseLot <= 0.0)
        {
         double minVol = 0.0;
         for(int i = 0; i < g_state.levelCount; i++)
            if(PositionSelectByTicket(g_state.tickets[i]))
              {
               double v = PositionGetDouble(POSITION_VOLUME);
               if(minVol == 0.0 || v < minVol) minVol = v;
              }
         g_state.baseLot = minVol;
         Log(LOG_WARN, StringFormat("Reconcile: baseLot lost with state file - derived %.2f from smallest open volume; recovery lot math may differ from original intent", g_state.baseLot));
        }
      Log(LOG_ERROR, StringFormat("Reconcile: %d live level(s) but NO state file - overrides reset to defaults, adoptionTime set to now. Any tagged magic-0 L1 is NOT auto-grafted: manual review required.", live.levelCount));
     }
   ResetExitEnforcement();   // post-restart enforcement recomputes from scratch (S7)
   ReconcileManualExits(file, haveFile);   // b24: manual ownership over the death window (M7) - runs AFTER the reset it seeds
   CancelOwnPendingOrders("live sequence restored at init");   // P8. (P9: a pending found while FLAT is left alone - it registers on fill.)
   StateSave(g_state);
   LogStructure();
   Log(LOG_INFO, StringFormat("Reconcile complete: dir=%s levels=%d%s", g_state.direction > 0 ? "BUY" : "SELL", g_state.levelCount, g_state.adoptedL1 ? " (adopted L1)" : ""));
  }

//+------------------------------------------------------------------+
//| SELF-TEST (Stage 1 verification aid)                             |
//| Writes a synthetic state to a temp file, reads it back, compares |
//| field by field. PASS/FAIL logged. Deletes temp file after.       |
//+------------------------------------------------------------------+
bool RunStateSelfTest()
  {
   string realFile = g_stateFile;
   g_stateFile = TRTM_DIR_BASE + "selftest_" + g_symbolNorm + ".json";

   SequenceState w;
   StateReset(w);
   w.direction = -1;
   w.levelCount = 3;
   w.tickets[0] = 111; w.tickets[1] = 222; w.tickets[2] = 333;
   w.levels[0] = 1;    w.levels[1] = 2;    w.levels[2] = 3;
   w.trailOverride  = true;
   w.beOverride     = false;
   w.trailingActive = true;
   w.beApplied      = false;
   w.adoptionTime   = D'2026.01.01 00:00';
   w.lastCloseTime  = D'2026.01.02 00:00';
   w.baseLot        = 0.03;
   w.manualTP       = 1234.56789;   // b24: new persisted fields covered
   w.manualSL       = 987.654;

   bool ok = StateSave(w);
   SequenceState r;
   ok = ok && StateLoad(r);
   ok = ok && (r.direction == w.direction);
   ok = ok && (r.levelCount == w.levelCount);
   ok = ok && (r.tickets[0] == 111 && r.tickets[1] == 222 && r.tickets[2] == 333);
   ok = ok && (r.levels[2] == 3);
   ok = ok && (r.trailOverride == true) && (r.beOverride == false);
   ok = ok && (r.trailingActive == true) && (r.beApplied == false);
   ok = ok && (r.adoptionTime == w.adoptionTime);
   ok = ok && (r.lastCloseTime == w.lastCloseTime);
   ok = ok && (MathAbs(r.baseLot - w.baseLot) < 0.0000001);
   ok = ok && (MathAbs(r.manualTP - w.manualTP) < 0.0000001);   // b24
   ok = ok && (MathAbs(r.manualSL - w.manualSL) < 0.0000001);   // b24

   FileDelete(g_stateFile);
   g_stateFile = realFile;
   Log(ok ? LOG_INFO : LOG_ERROR, StringFormat("State persistence self-test: %s", ok ? "PASS" : "FAIL"));
   return ok;
  }

//+------------------------------------------------------------------+
//| GUI PANEL + DASHBOARD (Stage 5)                                  |
//| Input surfaces and displays ONLY - no changes to adoption,       |
//| recovery, or exit behavior. Locked rules this stage:             |
//|  - Two-step confirm on every money button (10s window, the       |
//|    confirm text shows the MM-computed lot / floating PnL)        |
//|  - E4: clicking the opposite entry button switches the arm       |
//|  - P7: one pending order max; pending must be canceled before    |
//|    a market entry is accepted                                    |
//|  - P8: the EA cancels its OWN pending order the moment a         |
//|    sequence starts by any path (adoption, button, reconcile)     |
//|  - Panel position/colors are constants: the Stage 1 input        |
//|    dialog layout is locked, no new inputs                        |
//+------------------------------------------------------------------+
const string PNL = "TRTM_";    // object-name prefix; deinit deletes by prefix
#define PNL_X          10
#define PNL_Y          30
#define PNL_W          340
#define PNL_ROW_H      16
#define PNL_PAD        10
#define PNL_HDR_H      22
#define PNL_BTN_H      22
#define PNL_BTN_GAP    6
#define PNL_FONT       "Consolas"
#define PNL_FSIZE      8
#define ARM_WINDOW_MS  10000       // confirm window (locked: 10s auto-revert)

#define COL_BG       C'18,22,28'
#define COL_BORDER   C'70,78,90'
#define COL_TEXT     clrGainsboro
#define COL_DIM      clrDarkGray
#define COL_BUY      C'36,140,90'
#define COL_BUY_ARM  C'20,190,115'
#define COL_SELL     C'170,60,55'
#define COL_SELL_ARM C'225,85,70'
#define COL_WARN     clrGoldenrod
#define COL_ACCENT   C'110,155,225'
#define COL_OFF      C'60,64,72'

enum ENUM_ARM_STATE
  {
   ARM_NONE  = 0,
   ARM_BUY   = 1,
   ARM_SELL  = 2,
   ARM_CLOSE = 3
  };

ENUM_ARM_STATE g_armState    = ARM_NONE;
ulong          g_armExpiryMs = 0;      // GetTickCount64() deadline
double         g_armLot      = 0.0;    // lot computed + clamped at ARM time (E1)
int            g_pendDir     = 0;      // placement line: 0 none, 1 buy, -1 sell
bool           g_entryEnabled = true;  // false: Percent Risk + SL=0 (locked rule)
//--- b17: config-blocked state (Jeff request, S6-1 finding). Invalid inputs no
//--- longer deinit the EA - it stays attached with ALL trading frozen, every
//--- button gray (b14 language: gray = config-blocked), and the first
//--- validation ERROR on the dashboard warning row. Never silent: live
//--- positions found while blocked are WARNed at init.
bool   g_configBlocked = false;
string g_cfgReason     = "";     // first validation ERROR (dashboard warning row)
bool   g_cfgCapture    = false;  // Log() records the first ERROR while true

//--- b19: mobile push for events the user must know about while away from
//--- the desktop (Jeff decision: NOTIFY, never auto-close - a config error
//--- must not cost an open, exit-protected position money). Requires the
//--- MetaQuotes ID in terminal Options -> Notifications; failure is logged
//--- once, never spammed.
bool   g_notifyFailed = false;   // sticky per attach: one failure WARN only
string g_notifyQueue[];          // b21: SendNotification is silently dropped
                                 // when called during OnInit (confirmed via
                                 // Journal in S6-22) - queue and flush from
                                 // the first OnTimer pass instead. The timer
                                 // runs even while config-blocked.
void NotifyMobile(const string msg)
  {
   int n = ArraySize(g_notifyQueue);
   ArrayResize(g_notifyQueue, n + 1);
   g_notifyQueue[n] = "TRTM " + g_symbolNorm + ": " + msg;
  }

void NotifyFlush()
  {
   if(g_notifyFailed && ArraySize(g_notifyQueue) > 0)
     { ArrayResize(g_notifyQueue, 0); return; }
   for(int i = 0; i < ArraySize(g_notifyQueue); i++)
     {
      if(!SendNotification(g_notifyQueue[i]))
        {
         g_notifyFailed = true;
         Log(LOG_WARN, "Mobile push FAILED - set your MetaQuotes ID in Options -> Notifications (further pushes suppressed this attach)");
         break;
        }
     }
   ArrayResize(g_notifyQueue, 0);
  }

//--- b19 Guard C pre-screen (b11 precedent: refuse at the DOOR, not at the
//--- first recovery signal). Fixed recovery mode only - all other modes are
//--- non-decreasing by construction once init passes. Gated on recovery
//--- being enabled: with recovery off the mismatch is harmless.
bool EntryLotRecoveryConsistent(const double lot, const bool silent = false)
  {
   if(!InpEnableRecovery || InpRecoveryMultMode != RM_FIXED)
      return true;
   if(lot <= InpFixedRecoveryLot + 0.0000001)
      return true;
   if(!silent)
      Log(LOG_WARN, StringFormat("Entry REFUSED: L1 lot %.2f > Fixed recovery lot %.2f - recovery levels could never be non-decreasing (Guard C pre-screen). Raise Fixed recovery lot or lower the entry lot.",
                                 lot, InpFixedRecoveryLot));
   return false;
  }

//--- Volume clamp for L1 entry lots. Mirrors ComputeLevelLot's broker
//--- normalization but rounds DOWN (risk-first: a risk- or ratio-derived
//--- lot must never round up past the configured risk). Clamping UP to
//--- the broker minimum is the one case that exceeds it - WARNed loudly.
double ClampEntryVolume(const double raw, const bool silent = false)
  {
   double step   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double volMin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double volMax = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lot = raw;
   if(step > 0.0)
      lot = MathFloor(lot / step + 0.0000001) * step;
   if(lot < volMin)
     {
      // Guard A (b10, LOCKED): never clamp UP - a lot the user did not
      // configure is a risk violation. Refuse instead (M1).
      if(!silent)
         Log(LOG_ERROR, StringFormat("Entry REFUSED: computed lot %.4f is below broker minimum %.2f - opening the minimum would EXCEED the configured money-management amount (Guard A). Adjust risk/ratio settings or use Fixed mode.", raw, volMin));
      return 0.0;
     }
   if(lot > volMax)
     {
      if(!silent)
         Log(LOG_WARN, StringFormat("Entry lot %.4f exceeds broker maximum %.2f - clamped down", raw, volMax));
      lot = volMax;
     }
   lot = NormalizeDouble(lot, 8);
   if(!silent && MathAbs(lot - raw) > 0.0000001)
      Log(LOG_INFO, StringFormat("Entry lot %.4f normalized to %.4f (step %.4f, min %.2f, max %.2f)", raw, lot, step, volMin, volMax));
   return lot;
  }

//--- L1 entry lot from the selected money-management mode. This is the
//--- first build where MM_BALANCE_RATIO and MM_PERCENT_RISK are
//--- executable. Returns 0.0 on any failure (caller refuses, logged).
double ComputeEntryLot(const bool silent = false)
  {
   // silent = display path (dashboard L1-lot row, 500ms): identical math,
   // no logging - the loud click path stays the single source of refusals.
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double raw = 0.0;
   switch(InpMoneyMode)
     {
      case MM_FIXED_LOT:
         raw = InpEntryLotSize;
         break;
      case MM_BALANCE_RATIO:
         if(InpBalancePerLot <= 0.0)
           {
            if(!silent)
               Log(LOG_ERROR, "Balance Ratio mode: Balance per 0.01 Lot <= 0 - entry refused");
            return 0.0;
           }
         raw = balance / InpBalancePerLot * 0.01;
         break;
      case MM_PERCENT_RISK:
        {
         if(InpStopLossPts <= 0)
           {
            if(!silent)
               Log(LOG_ERROR, "Percent Risk mode requires Stop Loss > 0 - entry refused (locked rule)");
            return 0.0;
           }
         double tickVal = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
         double tickSz  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         if(tickSz <= 0.0) tickSz = _Point;
         double perPointPerLot = tickVal * (_Point / tickSz);
         if(perPointPerLot <= 0.0)
           {
            if(!silent)
               Log(LOG_ERROR, "Percent Risk mode: symbol tick value unavailable - entry refused");
            return 0.0;
           }
         raw = (balance * InpRiskPercent / 100.0) / (InpStopLossPts * perPointPerLot);
         break;
        }
     }
   if(raw <= 0.0)
     {
      if(!silent)
         Log(LOG_ERROR, StringFormat("Entry lot computed as %.4f (<= 0) - entry refused. Check money-management inputs.", raw));
      return 0.0;
     }
   return ClampEntryVolume(raw, silent);
  }

// Guard B (b10, revised b12 - LOCKED): an SL distance that reaches at or
// below price zero is broken configuration. A buy stop would compute <= 0
// (Stage 3 would treat it as OFF and the trade would run UNPROTECTED);
// b12 (M4 revised, Jeff): the rule is DIRECTION-INDEPENDENT for
// consistency - broken SL config blocks ALL orders until fixed, even
// though a sell's far stop would technically be placeable. Checked at
// arm, at placement, at confirm (vs line price for pendings, M5), and
// at execution. silent = dashboard path.
bool EntrySLRealizable(const double refPx, const bool silent = false)
  {
   if(InpStopLossPts <= 0)
      return true;
   double stopDepth = refPx - InpStopLossPts * _Point;
   if(stopDepth > 0.0)
      return true;
   if(!silent)
      Log(LOG_ERROR, StringFormat("Entry REFUSED: Stop Loss %d pts from %s computes to %s (<= 0) - orders blocked until Stop Loss is reduced (Guard B).",
                                  InpStopLossPts, DoubleToString(refPx, _Digits), DoubleToString(stopDepth, _Digits)));
   return false;
  }

//--- Own pending orders (P7/P8). No persistence: the broker's order book
//--- is the truth, scanned on demand (terminal-is-truth).
int CountOwnPendingOrders()
  {
   int count = 0;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderGetInteger(ORDER_MAGIC) != g_magic) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
      count++;
     }
   return count;
  }

// Broker minimum distance (points) between a pending price and market.
// Read live - brokers can widen it (e.g. around news). 0 = server-side
// discretion, no fixed band published.
int BrokerStopsLevelPts()
  {
   return (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
  }

// b15: the P8 explainer only belongs on P8 cancels; a user-initiated
// cancel is a normal action (INFO), not a warning (Jeff finding in G9).
void CancelOwnPendingOrders(const string reason, const bool isP8 = true)
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderGetInteger(ORDER_MAGIC) != g_magic) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
      if(g_trade.OrderDelete(ticket))
        {
         if(isP8)
            Log(LOG_WARN, StringFormat("Pending order %I64u CANCELED: %s (P8: a pending must never fill into a live sequence)", ticket, reason));
         else
            Log(LOG_INFO, StringFormat("Pending order %I64u CANCELED: %s", ticket, reason));
        }
      else
         Log(LOG_ERROR, StringFormat("Pending order %I64u cancel FAILED (retcode %d: %s) - reason was: %s. Cancel it manually.", ticket, (int)g_trade.ResultRetcode(), g_trade.ResultRetcodeDescription(), reason));
     }
  }

//--- Direct L1 registration for EA-opened entries (button market orders
//--- and pending fills). NOT the adoption path: our magic, our tag,
//--- adoptedL1 = false. Cache lesson applied: called only AFTER the
//--- position exists at the broker; state is rebuilt from scratch here.
void RegisterButtonL1(const ulong ticket)
  {
   if(!PositionSelectByTicket(ticket))
     {
      Log(LOG_ERROR, StringFormat("RegisterButtonL1: ticket %I64u vanished before registration - manual review required", ticket));
      return;
     }
   int posDir = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 1 : -1;
   datetime keepLastClose = g_state.lastCloseTime;
   StateReset(g_state);
   g_state.lastCloseTime = keepLastClose;
   g_state.direction    = posDir;
   g_state.levelCount   = 1;
   g_state.tickets[0]   = ticket;
   g_state.levels[0]    = 1;
   g_state.adoptedL1    = false;                             // EA-owned, not adopted
   g_state.baseLot      = PositionGetDouble(POSITION_VOLUME);
   g_state.adoptionTime = TimeCurrent();
   ResetExitEnforcement();
   CancelOwnPendingOrders("sequence started (EA L1 registered)");   // P8 (no-op if this L1 WAS the pending)
   StateSave(g_state);
   LogStructure();
   Log(LOG_INFO, StringFormat("EA L1 REGISTERED: ticket %I64u %s %.2f lots @ %s. Exits apply next tick.",
                              ticket, posDir > 0 ? "BUY" : "SELL",
                              PositionGetDouble(POSITION_VOLUME),
                              DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), _Digits)));
  }

//--- Finds an untracked our-magic position carrying our L1 tag. Used
//--- right after a button market order, and every flat tick as the
//--- pending-fill watcher (P5) - which also covers a crash between
//--- OrderSend and registration (terminal-is-truth).
ulong FindUntrackedOurL1()
  {
   for(int i = 0; i < PositionsTotal(); i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != g_magic) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      int lvl = ParseLevelFromComment(PositionGetString(POSITION_COMMENT));
      if(lvl != 1)
        {
         if(lvl > 1 && !AlreadyLogged("orphan:" + (string)ticket))
            Log(LOG_ERROR, StringFormat("Our-magic L%d position %I64u present while FLAT - orphan level without a sequence. Manual review required.", lvl, ticket));
         continue;
        }
      bool tracked = false;
      for(int j = 0; j < g_state.levelCount; j++)
         if(g_state.tickets[j] == ticket) { tracked = true; break; }
      if(!tracked)
         return ticket;
     }
   return 0;
  }

void CheckOwnPendingFillWhenFlat()
  {
   ulong ticket = FindUntrackedOurL1();
   if(ticket == 0)
      return;
   Log(LOG_INFO, StringFormat("Own L1 position %I64u found while FLAT (pending fill or recovered send) - registering", ticket));
   RegisterButtonL1(ticket);
  }

//--- Arm state machine ------------------------------------------------
void CancelArm(const string why)
  {
   if(g_armState == ARM_NONE)
      return;
   Log(LOG_INFO, StringFormat("Confirm window canceled (%s was armed): %s",
                              g_armState == ARM_BUY ? "BUY" : g_armState == ARM_SELL ? "SELL" : "CLOSE", why));
   g_armState = ARM_NONE;
   g_armLot   = 0.0;
  }

int ArmSecondsLeft()
  {
   ulong now = GetTickCount64();
   if(now >= g_armExpiryMs)
      return 0;
   return (int)((g_armExpiryMs - now) / 1000) + 1;
  }

// Timer-driven maintenance: expiry + invalidation (E6/C4 - the state the
// arm was based on no longer holds).
void ArmMaintain()
  {
   if(g_armState == ARM_NONE)
      return;
   bool flat = (g_state.levelCount == 0);
   if((g_armState == ARM_BUY || g_armState == ARM_SELL) && !flat)
     {
      CancelArm("sequence started while armed - confirm refused (E6)");
      return;
     }
   if(g_armState == ARM_CLOSE && flat)
     {
      CancelArm("sequence already flat - nothing to close (C4)");
      return;
     }
   if(GetTickCount64() >= g_armExpiryMs)
      CancelArm("10s confirm window expired");
  }

//--- Floating PnL of tracked positions (confirm-close preview).
double SequenceFloatingPnL()
  {
   double pnl = 0.0;
   for(int i = 0; i < g_state.levelCount; i++)
     {
      if(!PositionSelectByTicket(g_state.tickets[i]))
         continue;
      pnl += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
     }
   return pnl;
  }

//--- Money actions ----------------------------------------------------
void ExecuteMarketEntry(const int dir)
  {
   // Re-checks at EXECUTION time (E2/E6): the arm-time state must still hold.
   if(g_state.levelCount > 0)
     {
      CancelArm("sequence live at confirm time - entry refused");
      return;
     }
   if(CountOwnPendingOrders() > 0)
     {
      CancelArm("pending order appeared - cancel it before a market entry (P7)");
      return;
     }
   double lot = g_armLot;   // the lot the user confirmed (computed at arm, E1)
   g_armState = ARM_NONE;
   g_armLot   = 0.0;
   if(lot <= 0.0)
     {
      Log(LOG_ERROR, "Entry confirm with no armed lot - refused");
      return;
     }
   string comment = g_symbolNorm;
   StringToLower(comment);
   comment += "_l1_" + (dir > 0 ? "buy" : "sell");
   g_trade.SetExpertMagicNumber(g_magic);
   g_trade.SetDeviationInPoints(1000000);   // locked rule: spread/deviation filters are recovery-only
   double px = (dir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                         : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(!EntrySLRealizable(px))
      return;   // Guard B re-check at execution price, reason logged
   bool sent = g_trade.PositionOpen(_Symbol, dir > 0 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL,
                                    lot, px, 0.0, 0.0, comment);
   uint rc = g_trade.ResultRetcode();
   if(!sent || (rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_DONE_PARTIAL && rc != TRADE_RETCODE_PLACED))
     {
      Log(LOG_ERROR, StringFormat("L1 %s entry FAILED (retcode %d: %s) - no retry, re-arm to try again (E7)",
                                  dir > 0 ? "BUY" : "SELL", rc, g_trade.ResultRetcodeDescription()));
      return;
     }
   Log(LOG_INFO, StringFormat("L1 %s OPENED via button: %.2f lots @ %s (deal %I64u)",
                              dir > 0 ? "BUY" : "SELL", lot,
                              DoubleToString(g_trade.ResultPrice(), _Digits), g_trade.ResultDeal()));
   ulong ticket = FindUntrackedOurL1();
   if(ticket == 0)
     {
      Log(LOG_ERROR, "L1 order reported filled but position not found - manual review required (flat watcher will register it if it appears)");
      return;
     }
   RegisterButtonL1(ticket);
  }

void RemovePlacementLine()
  {
   ObjectDelete(0, PNL + "PLINE");
   g_pendDir = 0;
  }

void StartPlacementLine(const int dir)
  {
   double px = (dir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                         : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   ObjectCreate(0, PNL + "PLINE", OBJ_HLINE, 0, 0, px);
   ObjectSetInteger(0, PNL + "PLINE", OBJPROP_COLOR, dir > 0 ? COL_BUY_ARM : COL_SELL_ARM);
   ObjectSetInteger(0, PNL + "PLINE", OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, PNL + "PLINE", OBJPROP_WIDTH, 1);
   ObjectSetInteger(0, PNL + "PLINE", OBJPROP_SELECTABLE, true);
   ObjectSetInteger(0, PNL + "PLINE", OBJPROP_SELECTED, true);   // draggable immediately
   g_pendDir = dir;
   Log(LOG_INFO, StringFormat("Pending %s placement line created at %s - drag to price, then CONFIRM (line is NOT persisted across restarts)",
                              dir > 0 ? "BUY" : "SELL", DoubleToString(px, _Digits)));
  }

// Order type inferred at confirm time from the line vs the fill side (P2).
void ConfirmPendingOrder()
  {
   if(g_pendDir == 0)
      return;
   if(g_state.levelCount > 0)
     {
      Log(LOG_WARN, "Pending confirm refused: a sequence started - placement aborted");
      RemovePlacementLine();
      return;
     }
   if(CountOwnPendingOrders() > 0)
     {
      Log(LOG_WARN, "Pending confirm refused: one pending order max (P7) - cancel the existing one first");
      return;
     }
   double lot = ComputeEntryLot();
   if(lot <= 0.0)
      return;   // reason already logged
   if(!EntryLotRecoveryConsistent(lot))
      return;   // b19 Guard C pre-screen, reason logged
   double price = NormalizePrice(ObjectGetDouble(0, PNL + "PLINE", OBJPROP_PRICE));
   if(!EntrySLRealizable(price))
      return;   // Guard B vs the LINE price (M5), reason logged; line kept for re-drag
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   // b15 pre-screen: broker stops-level band. Local refusal with numbers
   // beats a bare server 10015; the server stays authoritative (a tick
   // between click and check can still reject - P6 handles that race).
   int stopsPts = BrokerStopsLevelPts();
   double bandRef = (g_pendDir > 0) ? ask : bid;
   if(stopsPts > 0 && MathAbs(price - bandRef) < stopsPts * _Point)
     {
      Log(LOG_WARN, StringFormat("Pending confirm refused: line %s is %.0f pts from market (%s) - broker minimum is %d pts. Move the line and confirm again.",
                                 DoubleToString(price, _Digits), MathAbs(price - bandRef) / _Point,
                                 DoubleToString(bandRef, _Digits), stopsPts));
      return;
     }
   string comment = g_symbolNorm;
   StringToLower(comment);
   comment += "_l1_" + (g_pendDir > 0 ? "buy" : "sell");
   g_trade.SetExpertMagicNumber(g_magic);
   bool ok = false;
   string typeName;
   if(g_pendDir > 0)
     {
      if(price <= ask) { typeName = "BUY LIMIT"; ok = g_trade.BuyLimit(lot, price, _Symbol, 0.0, 0.0, ORDER_TIME_GTC, 0, comment); }
      else             { typeName = "BUY STOP";  ok = g_trade.BuyStop(lot, price, _Symbol, 0.0, 0.0, ORDER_TIME_GTC, 0, comment); }
     }
   else
     {
      if(price >= bid) { typeName = "SELL LIMIT"; ok = g_trade.SellLimit(lot, price, _Symbol, 0.0, 0.0, ORDER_TIME_GTC, 0, comment); }
      else             { typeName = "SELL STOP";  ok = g_trade.SellStop(lot, price, _Symbol, 0.0, 0.0, ORDER_TIME_GTC, 0, comment); }
     }
   uint rc = g_trade.ResultRetcode();
   if(!ok || (rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_PLACED))
     {
      // P6: broker reject - keep the line for re-drag, and say why in terms
      // of the ACTUAL retcode. b27 fix (found live): the old fixed "broker
      // min distance" suffix was printed for EVERY retcode and sent the
      // trader hunting a distance problem on a 10027 (AutoTrading off).
      string hint;
      if(rc == TRADE_RETCODE_CLIENT_DISABLES_AT)        // 10027
         hint = "AutoTrading is OFF (toolbar Algo Trading button) - enable it and confirm again. Distance was fine.";
      else if(rc == TRADE_RETCODE_SERVER_DISABLES_AT)   // 10026
         hint = "Auto trading disabled SERVER-side (broker/account setting).";
      else if(rc == TRADE_RETCODE_TRADE_DISABLED)       // 10017
         hint = "Trading disabled for this account/symbol at the broker.";
      else if(rc == TRADE_RETCODE_INVALID_PRICE || rc == TRADE_RETCODE_INVALID_STOPS)
         hint = StringFormat("Price/stops invalid: bid %s ask %s, broker min distance %d pts - move the line and confirm again.",
                             DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits),
                             DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits),
                             BrokerStopsLevelPts());
      else
         hint = StringFormat("Context: bid %s ask %s, broker min distance %d pts.",
                             DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits),
                             DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits),
                             BrokerStopsLevelPts());
      Log(LOG_WARN, StringFormat("%s @ %s REJECTED (retcode %d: %s) - line kept, re-drag and confirm again (P6). %s",
                                 typeName, DoubleToString(price, _Digits), rc, g_trade.ResultRetcodeDescription(), hint));
      return;
     }
   Log(LOG_INFO, StringFormat("%s placed: %.2f lots @ %s (order %I64u). Fill registers as L1; the order is canceled if a sequence starts first (P8).",
                              typeName, lot, DoubleToString(price, _Digits), g_trade.ResultOrder()));
   RemovePlacementLine();
  }

//--- Panel rendering --------------------------------------------------
void PanelLabelSet(const string name, const int x, const int y, const string text, const color clr)
  {
   if(ObjectFind(0, name) < 0)
     {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetString(0, name, OBJPROP_FONT, PNL_FONT);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, PNL_FSIZE);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
     }
   ObjectSetString(0, name, OBJPROP_TEXT, text == "" ? " " : text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
  }

void PanelButtonSet(const string name, const int x, const int y, const int w, const int h,
                    const string text, const color bg, const bool visible)
  {
   if(ObjectFind(0, name) < 0)
     {
      ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetString(0, name, OBJPROP_FONT, PNL_FONT);
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, PNL_FSIZE);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
      ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, COL_BORDER);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      // TPROBE1 (diagnostic fork, NOT the delivery chain): hypothesis is
      // that the visual tester excludes OBJPROP_HIDDEN objects from click
      // hit-testing. Live charts keep hidden=true (bit-identical there).
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, !MQLInfoInteger(MQL_TESTER));
      // TPROBE3 fix candidate: buttons must WIN hit-testing over the panel
      // background rectangle (ButtonProbe proved bare buttons state-toggle
      // in the tester; TRTM's do not -> overlap suspected).
      ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
     }
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg);
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_TIMEFRAMES, visible ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
  }

string TFShort(const ENUM_TIMEFRAMES tf)
  {
   string s = EnumToString(tf);
   StringReplace(s, "PERIOD_", "");
   return s;
  }

// Value strings follow the approved dashboard format (2026-07-13 mockup):
// label-left / value-right rows, ASCII separators only (file is ANSI -
// the mockup's middle-dot and multiply glyphs would mojibake in MetaEditor).
string MMShort()
  {
   switch(InpMoneyMode)
     {
      case MM_FIXED_LOT:     return StringFormat("Fixed %.2f", InpEntryLotSize);
      case MM_BALANCE_RATIO: return StringFormat("Balance ratio / %.0f", InpBalancePerLot);
      case MM_PERCENT_RISK:  return StringFormat("Risk %.1f%%", InpRiskPercent);
     }
   return "?";
  }

string RecModeShort()
  {
   switch(InpRecoveryMultMode)
     {
      case RM_INCREMENTAL:          return StringFormat("Incremental +%.2f", InpIncrementStep);
      case RM_FIXED:                return StringFormat("Fixed %.2f", InpFixedRecoveryLot);
      case RM_MARTINGALE:           return StringFormat("Martingale x%.1f", InpMartingaleMult);
      case RM_DEFERRED_INCREMENTAL: return StringFormat("Def-Incr +%.2f /%d", InpIncrementStep, InpDeferredStep);
      case RM_DEFERRED_MARTINGALE:  return StringFormat("Def-Mart x%.2f /%d", InpMartingaleMult, InpDeferredStep);
      case RM_MANUAL:               return "Manual list";
     }
   return "?";
  }

// Option B next-trigger value (locked): raw trigger + live fill-side price
// with the inequality that must be satisfied. Same math as the engine
// (shared ComputeRecoveryTrigger). Value-only: the row label supplies "Next".
string NextTriggerRowText()
  {
   if(g_state.levelCount == 0)
      return "-";
   if(!InpEnableRecovery)
      return "recovery disabled";
   if(g_state.trailingActive)
      return "trailing active";
   int nextLvl; double trigger, worst; datetime gateTime;
   if(!ComputeRecoveryTrigger(nextLvl, trigger, worst, gateTime))
      return "n/a";
   if(InpMaxRecoveryTrades > 0 && (nextLvl - 1) > InpMaxRecoveryTrades)
      return StringFormat("max %d levels reached", InpMaxRecoveryTrades);
   if(g_state.direction > 0)
      return StringFormat("L%d @ %s | ask %s <=",
                          nextLvl, DoubleToString(trigger, _Digits),
                          DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits));
   return StringFormat("L%d @ %s | bid %s >=",
                       nextLvl, DoubleToString(trigger, _Digits),
                       DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits));
  }

// First (only, per P7) own pending order, for the flat-state Pending row.
string OwnPendingSummary()
  {
   for(int i = 0; i < OrdersTotal(); i++)
     {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderGetInteger(ORDER_MAGIC) != g_magic) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
      string t = "?";
      switch((ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE))
        {
         case ORDER_TYPE_BUY_LIMIT:  t = "BUY LIMIT";  break;
         case ORDER_TYPE_BUY_STOP:   t = "BUY STOP";   break;
         case ORDER_TYPE_SELL_LIMIT: t = "SELL LIMIT"; break;
         case ORDER_TYPE_SELL_STOP:  t = "SELL STOP";  break;
        }
      return StringFormat("%s @ %s", t, DoubleToString(OrderGetDouble(ORDER_PRICE_OPEN), _Digits));
     }
   return "-";
  }

// Effective BE/Trail for display: input = default, override flag = per-
// sequence flip (effective = input XOR override; reset-to-default at
// sequence end is automatic because overrides reset to false). Stage 6
// engines will read the same expression - flagged for that design review.
bool EffectiveBE()    { return InpEnableBE       != g_state.beOverride;    }
bool EffectiveTrail() { return InpEnableTrailing != g_state.trailOverride; }

// One key/value row: dim label left, value right-aligned at the panel edge.
void PanelRow(const string key, const int y, const string label,
              const string value, const color valClr)
  {
   PanelLabelSet(PNL + "L_" + key, PNL_X + PNL_PAD, y, label, COL_DIM);
   string vname = PNL + "V_" + key;
   if(ObjectFind(0, vname) < 0)
     {
      ObjectCreate(0, vname, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, vname, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, vname, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
      ObjectSetInteger(0, vname, OBJPROP_XDISTANCE, PNL_X + PNL_W - PNL_PAD);
      ObjectSetInteger(0, vname, OBJPROP_YDISTANCE, y);
      ObjectSetString(0, vname, OBJPROP_FONT, PNL_FONT);
      ObjectSetInteger(0, vname, OBJPROP_FONTSIZE, PNL_FSIZE);
      ObjectSetInteger(0, vname, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, vname, OBJPROP_HIDDEN, true);
     }
   ObjectSetString(0, vname, OBJPROP_TEXT, value == "" ? "-" : value);
   ObjectSetInteger(0, vname, OBJPROP_COLOR, valClr);
  }

void PanelRefresh()
  {
   bool flat = (g_state.levelCount == 0);
   if(!flat && g_pendDir != 0)
     {
      // A sequence started (adoption / pending fill) while the placement
      // line was up: placement is void - remove it, never leave it live.
      Log(LOG_INFO, "Placement line removed: a sequence started before the pending was confirmed");
      RemovePlacementLine();
     }
   bool pendingLive = (CountOwnPendingOrders() > 0);
   bool placing     = (g_pendDir != 0);
   int  y = PNL_Y + PNL_HDR_H + 8;

   // --- Header band: build left, symbol right ---
   PanelLabelSet(PNL + "H_TTL", PNL_X + PNL_PAD, PNL_Y + 5, "TRTM " + TRTM_BUILD, clrWhite);
   PanelRow("HSYM", PNL_Y + 5, "", g_symbolNorm, COL_DIM);   // reuses the right-anchor value slot

   // --- CONFIG section ---
   PanelLabelSet(PNL + "S_CFG", PNL_X + PNL_PAD, y, "CONFIG", COL_DIM);
   y += PNL_ROW_H;
   PanelRow("MAG", y, "Magic", (string)(int)g_magic, COL_TEXT);
   y += PNL_ROW_H;
   PanelRow("MM",  y, "Risk mode", MMShort(), COL_TEXT);
   y += PNL_ROW_H;
   string lotVal = "-";
   color  lotClr = COL_TEXT;
   double dispLot = 0.0;
   if(g_entryEnabled)
     {
      dispLot = ComputeEntryLot(true);   // silent display path
      if(dispLot > 0.0) lotVal = DoubleToString(dispLot, 2);
      else { lotVal = "blocked"; lotClr = COL_WARN; }   // Guard A / bad config (M6)
     }
   PanelRow("LOT", y, "L1 lot", lotVal, lotClr);
   y += PNL_ROW_H;
   PanelRow("REC", y, "Recovery",
            InpEnableRecovery ? "ON - " + RecModeShort() : "OFF",
            InpEnableRecovery ? COL_BUY_ARM : COL_DIM);
   y += PNL_ROW_H;
   PanelRow("INT", y, "Interval",
            StringFormat("%d pts - max %s", InpRecoveryIntervalPts,
                         InpMaxRecoveryTrades > 0 ? (string)InpMaxRecoveryTrades : "-"),
            COL_TEXT);
   y += PNL_ROW_H + 4;

   // --- divider ---
   string dv = PNL + "DIV1";
   if(ObjectFind(0, dv) < 0)
     {
      ObjectCreate(0, dv, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, dv, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, dv, OBJPROP_XDISTANCE, PNL_X + PNL_PAD);
      ObjectSetInteger(0, dv, OBJPROP_XSIZE, PNL_W - 2 * PNL_PAD);
      ObjectSetInteger(0, dv, OBJPROP_YSIZE, 1);
      ObjectSetInteger(0, dv, OBJPROP_BGCOLOR, COL_BORDER);
      ObjectSetInteger(0, dv, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, dv, OBJPROP_COLOR, COL_BORDER);
      ObjectSetInteger(0, dv, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, dv, OBJPROP_HIDDEN, true);
     }
   ObjectSetInteger(0, dv, OBJPROP_YDISTANCE, y);
   y += 8;

   // --- LIVE SEQUENCE section ---
   PanelLabelSet(PNL + "S_LIVE", PNL_X + PNL_PAD, y, "LIVE SEQUENCE", COL_DIM);
   y += PNL_ROW_H;

   double tp = 0.0, sl = 0.0, lots = 0.0, pTP = 0.0, pSL = 0.0, avgEntry = 0.0;
   int maxLvl = 0;
   if(!flat)
     {
      ComputeTargets(tp, sl);
      // b26: display truth includes manual ownership - the TP row and the
      // projection must show what is actually at the broker, not the computed
      // value the trader overrode (found live: Proj at TP froze on computed
      // while the sequence ran on the manual target).
      if(g_state.manualTP > 0.0 && !g_state.trailingActive)
         tp = g_state.manualTP;
      if(g_state.manualSL > 0.0)
         sl = g_state.manualSL;
      // Stage 6 display truth: once trailing owns the exit the TP is gone and
      // the REAL stop is the broker-side ratchet - project from those, not
      // from the stale anchor values (engine transitions stay in EnforceExits).
      if(g_state.trailingActive)
        {
         tp = 0.0;
         double liveSL0 = 0.0;
         for(int i = 0; i < g_state.levelCount; i++)
            if(PositionSelectByTicket(g_state.tickets[i]))
               liveSL0 = ProtectiveSL(liveSL0, PositionGetDouble(POSITION_SL), g_state.direction);
         if(liveSL0 > 0.0)
            sl = liveSL0;
        }
      ComputeProjection(tp, sl, lots, pTP, pSL, avgEntry);
      for(int i = 0; i < g_state.levelCount; i++)
         if(g_state.levels[i] > maxLvl) maxLvl = g_state.levels[i];
     }

   PanelRow("DIR", y, "Direction",
            flat ? "FLAT" : StringFormat("%s - L%d", g_state.direction > 0 ? "BUY" : "SELL", maxLvl),
            flat ? COL_TEXT : (g_state.direction > 0 ? COL_BUY_ARM : COL_SELL_ARM));
   y += PNL_ROW_H;
   PanelRow("POS", y, "Positions / lots",
            flat ? "-" : StringFormat("%d / %.2f", g_state.levelCount, lots), COL_TEXT);
   y += PNL_ROW_H;
   double fpnl = flat ? 0.0 : SequenceFloatingPnL();
   PanelRow("FPN", y, "Floating PnL",
            flat ? "-" : StringFormat("%+.2f %s", fpnl, AccountInfoString(ACCOUNT_CURRENCY)),
            flat ? COL_TEXT : (fpnl >= 0.0 ? COL_BUY_ARM : COL_SELL_ARM));
   y += PNL_ROW_H;
   PanelRow("AVG", y, "Avg entry", flat ? "-" : DoubleToString(avgEntry, _Digits), COL_TEXT);
   y += PNL_ROW_H;
   PanelRow("TP",  y, "TP",
            (!flat && g_state.trailingActive) ? "trailing"
            : ((!flat && tp > 0.0) ? DoubleToString(tp, _Digits)
               + (g_state.manualTP > 0.0 ? " [MANUAL]" : "") : "-"), COL_TEXT);
   y += PNL_ROW_H;
   // b21: the SL row shows the LIVE broker stop when one is placed (found in
   // S6-7: the row kept showing the anchor while the real stop sat at BE).
   double liveSLRow = 0.0;
   if(!flat)
      for(int i = 0; i < g_state.levelCount; i++)
         if(PositionSelectByTicket(g_state.tickets[i]))
            liveSLRow = ProtectiveSL(liveSLRow, PositionGetDouble(POSITION_SL), g_state.direction);
   PanelRow("SL",  y, "SL",
            ((!flat && liveSLRow > 0.0) ? DoubleToString(liveSLRow, _Digits)
             : ((!flat && sl > 0.0) ? DoubleToString(sl, _Digits) : "-"))
            + ((!flat && g_state.manualSL > 0.0) ? " [MANUAL]" : ""), COL_TEXT);
   y += PNL_ROW_H;
   PanelRow("PRJ", y, "Proj at TP / SL",
            flat ? "-" : StringFormat("%s / %s",
                                      tp > 0.0 ? StringFormat("%+.2f", pTP) : "n/a",
                                      sl > 0.0 ? StringFormat("%+.2f", pSL) : "n/a"),
            COL_TEXT);
   y += PNL_ROW_H;
   // Stage 6 (b16): rows carry the live engine state per the approved mockup.
   // Display-only: transitions belong to EnforceExits (single evaluator).
   string beMark = (!flat && g_state.beOverride)    ? "*" : "";
   string trMark = (!flat && g_state.trailOverride) ? "*" : "";
   string beVal; color beClr;
   if(!EffectiveBE())            { beVal = "OFF" + beMark;  beClr = COL_DIM; }
   else if(flat)                 { beVal = "ON";            beClr = COL_TEXT; }
   else if(g_state.beApplied)    { beVal = "SET @ "   + DoubleToString(BEStopPrice(), _Digits) + beMark; beClr = COL_BUY_ARM; }
   else                          { beVal = "ARMED @ " + DoubleToString(NormalizePrice(avgEntry + g_state.direction * InpBETriggerPts * _Point), _Digits) + beMark; beClr = COL_WARN; }
   PanelRow("BE",  y, "BE", beVal, beClr);
   y += PNL_ROW_H;
   string trVal; color trClr;
   if(!EffectiveTrail())              { trVal = "OFF" + trMark; trClr = COL_DIM; }
   else if(flat)                      { trVal = "ON";           trClr = COL_TEXT; }
   else if(g_state.trailingActive)
     {
      double liveSL = 0.0;
      for(int i = 0; i < g_state.levelCount; i++)
         if(PositionSelectByTicket(g_state.tickets[i]))
            liveSL = ProtectiveSL(liveSL, PositionGetDouble(POSITION_SL), g_state.direction);
      trVal = "TRAIL @ " + (liveSL > 0.0 ? DoubleToString(liveSL, _Digits) : "pending") + trMark;
      trClr = COL_BUY_ARM;
     }
   else                               { trVal = "ARMED @ " + DoubleToString(TrailActivationPrice(), _Digits) + trMark; trClr = COL_WARN; }
   PanelRow("TR",  y, "Trail", trVal, trClr);
   y += PNL_ROW_H;
   string pndVal = "-";
   color  pndClr = COL_TEXT;
   if(placing)
     {
      // b15: live distance guidance while the line is being placed.
      double linePx  = ObjectGetDouble(0, PNL + "PLINE", OBJPROP_PRICE);
      double bandRef = (g_pendDir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                                       : SymbolInfoDouble(_Symbol, SYMBOL_BID);
      int stopsPts = BrokerStopsLevelPts();
      bool inBand  = (stopsPts > 0 && MathAbs(linePx - bandRef) < stopsPts * _Point);
      pndVal = StringFormat("line %s | min %d pts%s", DoubleToString(linePx, _Digits),
                            stopsPts, inBand ? " TOO CLOSE" : "");
      pndClr = inBand ? COL_WARN : COL_ACCENT;
     }
   else if(pendingLive)
     {
      pndVal = OwnPendingSummary();
      pndClr = COL_ACCENT;
     }
   PanelRow("PND", y, "Pending", pndVal, pndClr);
   y += PNL_ROW_H;
   PanelRow("NXT", y, "Next", NextTriggerRowText(), COL_ACCENT);
   y += PNL_ROW_H;

   // Warning row: full-width, amber. Dup/unmanaged while live; while flat
   // the MMT-off candidate notice or the disabled-buttons reason.
   string warn = flat ? g_dashMMTNotice : g_dashWarn;
   if(g_configBlocked)
      warn = "BLOCKED: " + (g_cfgReason == "" ? "invalid inputs (see log)" : g_cfgReason);
      // outranks every other warning; b18 wraps long text below
   if(flat)
     {
      g_dashWarn = "";   // per-sequence warn cleared once flat
      if(warn == "" && !g_entryEnabled)
         warn = "entry buttons DISABLED: Risk mode needs SL > 0";
      // b13: BOTH guards announce themselves on the warning row while
      // flat (b12 only hinted Guard B - Guard A's only signal was the
      // "blocked" lot value, found by Jeff in G7b).
      if(warn == "" && g_entryEnabled
         && !EntrySLRealizable(SymbolInfoDouble(_Symbol, SYMBOL_BID), true))
         warn = "orders blocked: reduce Stop Loss (Guard B)";
      if(warn == "" && g_entryEnabled && dispLot <= 0.0)
         warn = "orders blocked: lot < broker min (Guard A)";
      if(warn == "" && g_entryEnabled && dispLot > 0.0 && !EntryLotRecoveryConsistent(dispLot, true))
         warn = StringFormat("orders blocked: L1 lot %.2f > Fixed recovery %.2f (Guard C)", dispLot, InpFixedRecoveryLot);
     }
   // b18 (Jeff request, S6-1 dashboard): word-wrap the warning to fit the
   // panel (Consolas 8pt, ~45 chars usable) instead of truncating. Up to
   // 3 lines; anything longer ends in "..." with the full text in the log.
   // The button grid and background height flow down with the extra lines.
   string wl[3]; wl[0] = " "; wl[1] = ""; wl[2] = "";
   int nWarnLines = 1;
   if(warn != "")
     {
      const int maxChars = 45;
      string rest = warn;
      for(int li = 0; li < 3; li++)
        {
         if(StringLen(rest) <= maxChars)
           { wl[li] = rest; nWarnLines = li + 1; rest = ""; break; }
         int cut = -1;
         for(int c = maxChars; c > 20; c--)
            if(StringGetCharacter(rest, c) == ' ') { cut = c; break; }
         if(cut < 0) cut = maxChars;
         wl[li] = StringSubstr(rest, 0, cut);
         rest = StringSubstr(rest, cut);
         StringTrimLeft(rest);
         nWarnLines = li + 1;
        }
      if(rest != "")
         wl[2] = StringSubstr(wl[2], 0, MathMax(0, StringLen(wl[2]) - 3)) + "...";
     }
   for(int li = 0; li < 3; li++)
     {
      PanelLabelSet(PNL + "WRN" + (string)li, PNL_X + PNL_PAD, y,
                    (li < nWarnLines && wl[li] != "") ? wl[li] : " ", COL_WARN);
      if(li < nWarnLines)
         y += PNL_ROW_H;
     }
   y += 6;

   // --- Buttons: aligned to the KV grid (locked geometry: two half-width
   // columns of (PNL_W - 2*PNL_PAD - PNL_BTN_GAP)/2, or one full-width) ---
   int bw2 = (PNL_W - 2 * PNL_PAD - PNL_BTN_GAP) / 2;   // half-width button
   int bwF = PNL_W - 2 * PNL_PAD;                       // full-width button
   int xb  = PNL_X + PNL_PAD;
   int by0 = y;
   int by1 = by0 + PNL_BTN_H + PNL_BTN_GAP;
   int by2 = by1 + PNL_BTN_H + PNL_BTN_GAP;

   // b12: one clickable flag for all four order buttons - Guard B is
   // direction-independent (M4 revised: broken SL config blocks ALL
   // orders). Silent checks only.
   bool entryClickable = flat && g_entryEnabled && !pendingLive && dispLot > 0.0
                         && EntrySLRealizable(SymbolInfoDouble(_Symbol, SYMBOL_BID), true)
                         && EntryLotRecoveryConsistent(dispLot, true);   // b19 Guard C pre-screen
   color buyCol  = entryClickable ? (g_armState == ARM_BUY  ? COL_BUY_ARM  : COL_BUY)  : COL_OFF;
   color sellCol = entryClickable ? (g_armState == ARM_SELL ? COL_SELL_ARM : COL_SELL) : COL_OFF;
   string buyTxt  = (g_armState == ARM_BUY)  ? StringFormat("CONFIRM BUY %.2f %ds",  g_armLot, ArmSecondsLeft()) : "BUY";
   string sellTxt = (g_armState == ARM_SELL) ? StringFormat("CONFIRM SELL %.2f %ds", g_armLot, ArmSecondsLeft()) : "SELL";
   // b14 (Jeff): hidden = structurally unavailable (live / pending-live /
   // placing), gray = config-blocked (guards, Risk+SL=0). A live pending
   // makes market entry structurally unavailable (P7), so BUY/SELL hide
   // instead of graying; the P7 refusal code remains as defense-in-depth.
   PanelButtonSet(PNL + "B_BUY",  xb,                       by0, bw2, PNL_BTN_H, buyTxt,  buyCol,  flat && !pendingLive);
   PanelButtonSet(PNL + "B_SELL", xb + bw2 + PNL_BTN_GAP,   by0, bw2, PNL_BTN_H, sellTxt, sellCol, flat && !pendingLive);

   string closeTxt = (g_armState == ARM_CLOSE)
                     ? StringFormat("CONFIRM CLOSE %+.2f %ds", SequenceFloatingPnL(), ArmSecondsLeft())
                     : "CLOSE SEQUENCE";
   PanelButtonSet(PNL + "B_CLOSE", xb, by0, bwF, PNL_BTN_H, closeTxt,
                  g_armState == ARM_CLOSE ? COL_SELL_ARM : COL_SELL, !flat);

   // Pending row (flat only)
   if(placing)
     {
      double linePx = ObjectGetDouble(0, PNL + "PLINE", OBJPROP_PRICE);
      double refPx  = (g_pendDir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) : SymbolInfoDouble(_Symbol, SYMBOL_BID);
      string ptype  = (g_pendDir > 0) ? (linePx <= refPx ? "BLIMIT" : "BSTOP")
                                      : (linePx >= refPx ? "SLIMIT" : "SSTOP");
      PanelButtonSet(PNL + "B_PCONF", xb, by1, bw2 + 40, PNL_BTN_H,
                     StringFormat("CONFIRM %s %s", ptype, DoubleToString(linePx, _Digits)),
                     g_pendDir > 0 ? COL_BUY_ARM : COL_SELL_ARM, flat);
      PanelButtonSet(PNL + "B_PCXL",  xb + bw2 + 40 + PNL_BTN_GAP, by1, bwF - (bw2 + 40) - PNL_BTN_GAP, PNL_BTN_H,
                     "CANCEL", COL_OFF, flat);
      PanelButtonSet(PNL + "B_PBUY",  xb, by1, 10, 10, "", COL_OFF, false);
      PanelButtonSet(PNL + "B_PSELL", xb, by1, 10, 10, "", COL_OFF, false);
      PanelButtonSet(PNL + "B_CXLP",  xb, by1, 10, 10, "", COL_OFF, false);
     }
   else if(pendingLive)
     {
      // One pending max (P7): CANCEL PENDING is the only meaningful action;
      // it takes row A since BUY/SELL are hidden (b14).
      PanelButtonSet(PNL + "B_CXLP",  xb, by0, bwF, PNL_BTN_H, "CANCEL PENDING", COL_WARN, flat);
      PanelButtonSet(PNL + "B_PBUY",  xb, by1, 10, 10, "", COL_OFF, false);
      PanelButtonSet(PNL + "B_PSELL", xb, by1, 10, 10, "", COL_OFF, false);
      PanelButtonSet(PNL + "B_PCONF", xb, by1, 10, 10, "", COL_OFF, false);
      PanelButtonSet(PNL + "B_PCXL",  xb, by1, 10, 10, "", COL_OFF, false);
     }
   else
     {
      PanelButtonSet(PNL + "B_PBUY",  xb,                     by1, bw2, PNL_BTN_H, "PEND BUY",  entryClickable ? COL_BUY  : COL_OFF, flat);
      PanelButtonSet(PNL + "B_PSELL", xb + bw2 + PNL_BTN_GAP, by1, bw2, PNL_BTN_H, "PEND SELL", entryClickable ? COL_SELL : COL_OFF, flat);
      PanelButtonSet(PNL + "B_CXLP",  xb, by1, 10, 10, "", COL_OFF, false);
      PanelButtonSet(PNL + "B_PCONF", xb, by1, 10, 10, "", COL_OFF, false);
      PanelButtonSet(PNL + "B_PCXL",  xb, by1, 10, 10, "", COL_OFF, false);
     }

   // BE / Trail toggles (always visible; per-sequence overrides)
   PanelButtonSet(PNL + "B_BE",    xb,                     by2, bw2, PNL_BTN_H,
                  StringFormat("BE: %s%s",    EffectiveBE()    ? "ON" : "OFF", (!flat && g_state.beOverride)    ? "*" : ""),
                  EffectiveBE()    ? COL_BUY  : COL_OFF, true);
   PanelButtonSet(PNL + "B_TRAIL", xb + bw2 + PNL_BTN_GAP, by2, bw2, PNL_BTN_H,
                  StringFormat("TRAIL: %s%s", EffectiveTrail() ? "ON" : "OFF", (!flat && g_state.trailOverride) ? "*" : ""),
                  EffectiveTrail() ? COL_BUY  : COL_OFF, true);

   // b17: config-blocked = every button gray (b14 language), clicks refused
   // in HandlePanelClick. Visibility untouched - hidden means structurally
   // unavailable, and that is not what a bad config is.
   if(g_configBlocked)
     {
      string btns[] = {"B_BUY","B_SELL","B_CLOSE","B_PBUY","B_PSELL","B_PCONF","B_PCXL","B_CXLP","B_BE","B_TRAIL"};
      for(int i = 0; i < ArraySize(btns); i++)
         ObjectSetInteger(0, PNL + btns[i], OBJPROP_BGCOLOR, COL_OFF);
     }

   // b18: panel height follows the (now dynamic) button grid bottom, so
   // extra warning lines push the frame down instead of overflowing it.
   ObjectSetInteger(0, PNL + "BG", OBJPROP_YSIZE, (by2 + PNL_BTN_H + 10) - PNL_Y);

   ChartRedraw();
  }

void PanelCreate()
  {
   // Baseline height from the fixed row grid (1 warning line assumed);
   // PanelRefresh re-sizes the background dynamically when the warning
   // wraps to more lines (b18) - this value only avoids a first-frame jump.
   int h = PNL_HDR_H + 8
           + PNL_ROW_H * (1 + 5) + 4 + 8            // CONFIG + divider gap
           + PNL_ROW_H * (1 + 11)                   // LIVE SEQUENCE + rows
           + PNL_ROW_H + 6                          // warning row
           + 3 * PNL_BTN_H + 2 * PNL_BTN_GAP + 10;  // buttons + bottom pad
   string bg = PNL + "BG";
   if(ObjectFind(0, bg) < 0)
     {
      ObjectCreate(0, bg, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, bg, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, bg, OBJPROP_XDISTANCE, PNL_X);
      ObjectSetInteger(0, bg, OBJPROP_YDISTANCE, PNL_Y);
      ObjectSetInteger(0, bg, OBJPROP_XSIZE, PNL_W);
      ObjectSetInteger(0, bg, OBJPROP_BGCOLOR, COL_BG);
      ObjectSetInteger(0, bg, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, bg, OBJPROP_COLOR, COL_BORDER);
      ObjectSetInteger(0, bg, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, bg, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, bg, OBJPROP_BACK, false);
     }
   ObjectSetInteger(0, bg, OBJPROP_YSIZE, h);
   // Header band (slightly lighter strip behind the title row)
   string hb = PNL + "HB";
   if(ObjectFind(0, hb) < 0)
     {
      ObjectCreate(0, hb, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, hb, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, hb, OBJPROP_XDISTANCE, PNL_X + 1);
      ObjectSetInteger(0, hb, OBJPROP_YDISTANCE, PNL_Y + 1);
      ObjectSetInteger(0, hb, OBJPROP_XSIZE, PNL_W - 2);
      ObjectSetInteger(0, hb, OBJPROP_YSIZE, PNL_HDR_H);
      ObjectSetInteger(0, hb, OBJPROP_BGCOLOR, C'30,35,42');
      ObjectSetInteger(0, hb, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, hb, OBJPROP_COLOR, C'30,35,42');
      ObjectSetInteger(0, hb, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, hb, OBJPROP_HIDDEN, true);
     }
   PanelRefresh();
  }

void PanelDestroy()
  {
   ObjectsDeleteAll(0, PNL);   // X3: everything the panel ever drew, by prefix
   ChartRedraw();
  }

//--- Click dispatch ---------------------------------------------------
void HandleEntryClick(const int dir)
  {
   if(g_state.levelCount > 0)
     {
      Log(LOG_WARN, "Entry click while a sequence is live - refused");
      return;
     }
   if(!g_entryEnabled)
     {
      Log(LOG_WARN, "Entry button DISABLED: Percentage Risk Mode with Stop Loss = 0 (locked rule). Set Stop Loss > 0 to enable.");
      return;
     }
   if(CountOwnPendingOrders() > 0)
     {
      Log(LOG_WARN, "Entry refused: a pending order is live - cancel it first (P7: one entry path at a time)");
      return;
     }
   if(g_pendDir != 0)
     {
      Log(LOG_INFO, "Placement line canceled: market entry armed instead");
      RemovePlacementLine();
     }
   ENUM_ARM_STATE want = (dir > 0) ? ARM_BUY : ARM_SELL;
   if(g_armState == want)
     {
      ExecuteMarketEntry(dir);   // second click = confirm
      return;
     }
   if(g_armState != ARM_NONE)
      CancelArm(StringFormat("switching arm to %s (E4)", dir > 0 ? "BUY" : "SELL"));
   double lot = ComputeEntryLot();
   if(lot <= 0.0)
      return;   // reason logged (Guard A / bad config)
   if(!EntryLotRecoveryConsistent(lot))
      return;   // b19 Guard C pre-screen, reason logged
   double refPx = (dir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                            : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(!EntrySLRealizable(refPx))
      return;   // Guard B, reason logged
   g_armState    = want;
   g_armLot      = lot;
   g_armExpiryMs = GetTickCount64() + ARM_WINDOW_MS;
   Log(LOG_INFO, StringFormat("%s ARMED: %.2f lots (%s) - click CONFIRM within 10s to execute",
                              dir > 0 ? "BUY" : "SELL", lot, MMShort()));
  }

void HandleCloseClick()
  {
   if(g_state.levelCount == 0)
     {
      Log(LOG_WARN, "Close click while flat - refused");
      return;
     }
   if(g_armState == ARM_CLOSE)
     {
      g_armState = ARM_NONE;
      Log(LOG_INFO, "Close CONFIRMED by user");
      CloseSequenceAtMarket("user close button (confirmed)");
      return;
     }
   if(g_armState != ARM_NONE)
      CancelArm("switching arm to CLOSE");
   g_armState    = ARM_CLOSE;
   g_armExpiryMs = GetTickCount64() + ARM_WINDOW_MS;
   Log(LOG_INFO, StringFormat("CLOSE ARMED: floating PnL %+.2f - click CONFIRM within 10s to close the whole sequence at market",
                              SequenceFloatingPnL()));
  }

void HandlePendStartClick(const int dir)
  {
   if(g_state.levelCount > 0)
     {
      Log(LOG_WARN, "Pending placement while a sequence is live - refused");
      return;
     }
   if(!g_entryEnabled)
     {
      Log(LOG_WARN, "Pending button DISABLED: Percentage Risk Mode with Stop Loss = 0 (locked rule). Set Stop Loss > 0 to enable.");
      return;
     }
   if(CountOwnPendingOrders() > 0)
     {
      Log(LOG_WARN, "Pending placement refused: one pending order max (P7) - cancel the existing one first");
      return;
     }
   // b11: guards pre-screen at PLACEMENT, same treatment as the
   // percent-risk-without-SL disable - no dead-end line the confirm would
   // refuse anyway. Confirm remains the authoritative gate (the line can
   // be dragged into a failing price after this passes).
   double preLot = ComputeEntryLot();   // loud - Guard A refuses here
   if(preLot <= 0.0)
      return;
   double refPx = (dir > 0) ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                            : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(!EntrySLRealizable(refPx))
      return;   // Guard B vs current price, reason logged
   if(g_armState != ARM_NONE)
      CancelArm("pending placement started instead");
   if(g_pendDir != 0)
      RemovePlacementLine();
   StartPlacementLine(dir);
  }

void HandleToggleClick(const bool isBE)
  {
   if(g_state.levelCount == 0)
     {
      Log(LOG_INFO, StringFormat("%s toggle is a PER-SEQUENCE override - no active sequence. Change the input default instead.", isBE ? "BE" : "Trailing"));
      return;
     }
   // Locked precedent (Stage 6): toggling OFF is only honored BEFORE the
   // feature has triggered. Past that point the flip is refused, not queued.
   if(isBE && g_state.beApplied && EffectiveBE())
     {
      Log(LOG_INFO, "BE toggle-off REFUSED: BE already triggered and the SL is placed (locked: off only honored before trigger)");
      return;
     }
   if(!isBE && g_state.trailingActive && EffectiveTrail())
     {
      Log(LOG_INFO, "Trailing toggle-off REFUSED: trailing already active, TP removed (locked: off only honored before activation)");
      return;
     }
   if(isBE)
      g_state.beOverride = !g_state.beOverride;
   else
      g_state.trailOverride = !g_state.trailOverride;
   StateSave(g_state);
   Log(LOG_WARN, StringFormat("%s override flipped for this sequence: effective %s%s",
                              isBE ? "BE" : "Trailing",
                              (isBE ? EffectiveBE() : EffectiveTrail()) ? "ON" : "OFF",
                              (isBE ? (EffectiveBE() && g_state.levelCount > 0) : (EffectiveTrail() && g_state.levelCount > 0))
                              ? " - engine evaluates from the next tick (fires immediately if the trigger is already met)" : ""));
   // b21 (found live in Stage 6): the CFG9 geometry check only ran at init
   // and only when the trailing INPUT was on - arming via this button never
   // saw it. Same math, delivered at the moment of arming, per TP phase.
   // Warning row lights only when EVERY phase is unreachable (fully inert).
   if(!isBE && EffectiveTrail())
     {
      int actPts = InpBEOffsetPts + InpTrailDistPts;
      bool l1Dead  = (InpInitialTPPts > 0 && actPts >= InpInitialTPPts);
      bool avgDead = (InpAvgTPPts > 0 && actPts >= InpAvgTPPts);
      if(l1Dead || avgDead)
         Log(LOG_WARN, StringFormat("Trail armed with activation avg+%d pts vs TP targets (Initial %d / Avg %d): %s%s%s - the broker TP fills first there (self-resolving, D4)",
                                    actPts, InpInitialTPPts, InpAvgTPPts,
                                    l1Dead ? "UNREACHABLE on L1" : "",
                                    (l1Dead && avgDead) ? " and " : "",
                                    avgDead ? "UNREACHABLE multi-level" : ""));
      if(l1Dead && avgDead)
         g_dashWarn = StringFormat("trail inert: activation %d pts >= all TP targets", actPts);
     }
  }

void HandlePanelClick(const string name)
  {
   if(g_configBlocked)
     {
      if(!AlreadyLogged("cfgclick"))
         Log(LOG_INFO, "Buttons are config-blocked - fix the inputs first (reason on the warning row)");
      ObjectSetInteger(0, name, OBJPROP_STATE, false);
      return;
     }
   if(name == PNL + "B_BUY")        HandleEntryClick(1);
   else if(name == PNL + "B_SELL")  HandleEntryClick(-1);
   else if(name == PNL + "B_CLOSE") HandleCloseClick();
   else if(name == PNL + "B_PBUY")  HandlePendStartClick(1);
   else if(name == PNL + "B_PSELL") HandlePendStartClick(-1);
   else if(name == PNL + "B_PCONF") ConfirmPendingOrder();
   else if(name == PNL + "B_PCXL")
     {
      Log(LOG_INFO, "Pending placement canceled by user (line removed, nothing sent)");
      RemovePlacementLine();
     }
   else if(name == PNL + "B_CXLP")  CancelOwnPendingOrders("user cancel button", false);
   else if(name == PNL + "B_BE")    HandleToggleClick(true);
   else if(name == PNL + "B_TRAIL") HandleToggleClick(false);
   else
      return;
   ObjectSetInteger(0, name, OBJPROP_STATE, false);   // un-press
   PanelRefresh();
  }

//+------------------------------------------------------------------+
//| INPUT VALIDATION                                                 |
//+------------------------------------------------------------------+
bool ValidateInputs()
  {
   bool ok = true;
   if(InpMoneyMode == MM_PERCENT_RISK && InpStopLossPts <= 0)
     {
      // Locked rule: Percentage Risk requires SL > 0. In Stage 5 this
      // also disables the entry buttons; at init we warn but do not
      // block, because adoption of mobile L1s must still work.
      Log(LOG_WARN, "Percentage Risk Mode selected with Stop Loss = 0: entry buttons will be DISABLED (Stage 5). Set Stop Loss > 0 to use this mode.");
     }
   if(InpRecoveryIntervalPts <= 0 && InpEnableRecovery)
     {
      Log(LOG_ERROR, "Recovery enabled but Recovery Interval <= 0 - invalid configuration");
      ok = false;
     }
   // Stage 6 (b16): BE/Trail geometry checks. UNCONDITIONAL - the per-
   // sequence override buttons can enable either engine at runtime, so the
   // constants must be coherent even when the input default is off.
   if(InpBEOffsetPts < 0)
     {
      Log(LOG_ERROR, "BE Offset < 0 - the offset is on the PROFIT side of avg by definition (0 = SL exactly at avg)");
      ok = false;
     }
   if(InpBEOffsetPts >= InpBETriggerPts)
     {
      Log(LOG_ERROR, StringFormat("BE Offset (%d) must be < BE Trigger (%d) - at trigger the SL would place at/through price", InpBEOffsetPts, InpBETriggerPts));
      ok = false;
     }
   if(InpTrailDistPts <= 0)
     {
      Log(LOG_ERROR, "Trailing Distance <= 0 - the trail SL would sit at/through price on every update");
      ok = false;
     }
   if(InpMinTrailStepPts < 0)
     {
      Log(LOG_ERROR, "Min Step to Update SL < 0 - invalid configuration");
      ok = false;
     }
   if(InpIncrementStep < 0 &&
      (InpRecoveryMultMode == RM_INCREMENTAL || InpRecoveryMultMode == RM_DEFERRED_INCREMENTAL))
     {
      Log(LOG_ERROR, "Increment step < 0 - recovery lots must be non-decreasing (Guard C geometry)");
      ok = false;
     }
   if(InpEnableTrailing)
     {
      int actPts = InpBEOffsetPts + InpTrailDistPts;
      if(InpAvgTPPts > 0 && actPts >= InpAvgTPPts)
         Log(LOG_WARN, StringFormat("Trail activation (offset %d + distance %d = %d pts) sits at/beyond Avg TP target %d pts - the broker TP will fill before trailing can activate (multi-level)",
                                    InpBEOffsetPts, InpTrailDistPts, actPts, InpAvgTPPts));
      if(InpInitialTPPts > 0 && actPts >= InpInitialTPPts)
         Log(LOG_WARN, StringFormat("Trail activation (%d pts) sits at/beyond Initial TP %d pts - the broker TP will fill before trailing can activate (L1 phase)",
                                    actPts, InpInitialTPPts));
      int stopsLvl = BrokerStopsLevelPts();
      if(stopsLvl > 0 && InpTrailDistPts > 0 && InpTrailDistPts <= stopsLvl)   // b21: <= 0 is already an ERROR above, no double-report
         Log(LOG_WARN, StringFormat("Trailing Distance %d pts <= broker stops level %d pts - every trail update will defer until the distance clears", InpTrailDistPts, stopsLvl));
     }
   if(InpInitialTPPts == 0 && InpAvgTPPts == 0 && !InpEnableTrailing)
      Log(LOG_WARN, "No TP targets and no trailing configured: sequences will have no profit exit until changed");
   if(InpMartingaleMult < 1.0 &&
      (InpRecoveryMultMode == RM_MARTINGALE || InpRecoveryMultMode == RM_DEFERRED_MARTINGALE))
     {
      Log(LOG_ERROR, "Martingale multiplier < 1.0 - invalid configuration");
      ok = false;
     }
   if(InpDeferredStep < 1 &&
      (InpRecoveryMultMode == RM_DEFERRED_INCREMENTAL || InpRecoveryMultMode == RM_DEFERRED_MARTINGALE))
     {
      Log(LOG_ERROR, "Deferred Step < 1 - invalid configuration");
      ok = false;
     }
   if(InpRecoveryMultMode == RM_FIXED && InpFixedRecoveryLot <= 0.0)
     {
      Log(LOG_ERROR, "Fixed recovery lot <= 0 - invalid configuration");
      ok = false;
     }
   // b19 (Jeff, after Guard C fired live in S6-5): the one statically
   // knowable declining-lot config is blocked at the source. Balance-ratio
   // and Percent-Risk entry lots are click-time values - the pre-screen
   // (EntryLotRecoveryConsistent) covers those at the door.
   if(InpEnableRecovery && InpRecoveryMultMode == RM_FIXED &&
      InpMoneyMode == MM_FIXED_LOT && InpFixedRecoveryLot < InpEntryLotSize)
     {
      Log(LOG_ERROR, StringFormat("Fixed recovery lot %.2f < Entry lot %.2f - recovery lots must be non-decreasing (Guard C). Raise Fixed recovery lot or lower the entry lot.",
                                  InpFixedRecoveryLot, InpEntryLotSize));
      ok = false;
     }
   if(InpRecoveryMultMode == RM_MANUAL && !ParseManualMultipliers())
     {
      Log(LOG_ERROR, "Manual Multiplier list could not be parsed - invalid configuration");
      ok = false;
     }
   if(InpRecoveryMultMode == RM_MANUAL && ArraySize(g_manualMult) > 0)
     {
      string mlist = "";
      for(int i = 0; i < ArraySize(g_manualMult); i++)
         mlist += (i > 0 ? ", " : "") + DoubleToString(g_manualMult[i], 2);
      Log(LOG_INFO, StringFormat("Manual Multipliers parsed: %d entries [%s] - levels beyond entry %d clamp to the last value",
                                 ArraySize(g_manualMult), mlist, ArraySize(g_manualMult)));
     }
   if(InpRecoveryMultMode == RM_MANUAL && ArraySize(g_manualMult) > 0 && MathAbs(g_manualMult[0] - 1.0) > 0.0001)
      Log(LOG_WARN, StringFormat("Manual Multiplier first entry is %.2f (applies to L1 conceptually) - L1 lot is whatever was actually opened; recovery levels scale from it using entries 2+", g_manualMult[0]));
   return ok;
  }

//+------------------------------------------------------------------+
//| SINGLE-INSTANCE GUARD (+ b22 heartbeat)                          |
//| b22: chart-exists is no longer proof of life. The owner stamps   |
//| _HB every 10s from OnTimer; an acquirer refuses only while the   |
//| stamp is fresh (<60s). Dead stamp + living chart = takeover      |
//| (chart-alive/EA-dead hole; kill tests 2026-07-16 proved flushed  |
//| locks survive TerminateProcess, so this shape was permanent).    |
//| One TRTM per symbol per terminal. Uses terminal global variables |
//| as a lock; cleared on deinit.                                    |
//| Storage (b6 fix): ChartID() is a 64-bit long (observed ~1.3e17), |
//| but terminal globals hold DOUBLES (53-bit mantissa). Storing the |
//| raw ID rounds it (granularity 16 at that magnitude), so the      |
//| owner failed to recognize its OWN lock: release silently skipped |
//| on param-change deinit, then re-init refused itself (orphaned    |
//| lock, found live on XAUUSD.s 2026-07-13). Fix: store the ID as   |
//| two 32-bit halves - each < 2^32 is exactly representable, so     |
//| round-trip is identity. Lock SEMANTICS are unchanged.            |
//+------------------------------------------------------------------+
string LockName()   { return TRTM_TAG + "_LOCK_" + g_symbolNorm; }        // legacy single-double format (pre-b6)
string LockNameHi() { return TRTM_TAG + "_LOCK_" + g_symbolNorm + "_HI"; }
string LockNameLo() { return TRTM_TAG + "_LOCK_" + g_symbolNorm + "_LO"; }
string LockNameHb() { return TRTM_TAG + "_LOCK_" + g_symbolNorm + "_HB"; }   // b22: heartbeat stamp (TimeLocal epoch)

// b22: heartbeat age in seconds. Returns -1 when the stamp is absent
// (legacy pre-b22 lock). A FUTURE stamp (clock edit/skew) reports age 0 =
// fresh: the anomaly is the acquirer's to WARN about, never a takeover
// license (matrix A7).
long LockHbAge()
  {
   if(!GlobalVariableCheck(LockNameHb()))
      return -1;
   long stamp = (long)GlobalVariableGet(LockNameHb());
   long age   = (long)TimeLocal() - stamp;
   return age < 0 ? 0 : age;
  }

bool LockHbFuture()
  {
   return GlobalVariableCheck(LockNameHb()) &&
          (long)GlobalVariableGet(LockNameHb()) > (long)TimeLocal();
  }

void LockHbWrite()
  {
   GlobalVariableSet(LockNameHb(), (double)(long)TimeLocal());
   GlobalVariablesFlush();   // same crash-survival contract as the lock itself (b7)
  }

// Reads the stored owner chart ID from the HI/LO pair. Returns false if
// the pair is absent/incomplete (no lock).
bool LockOwner(long &owner)
  {
   if(!GlobalVariableCheck(LockNameHi()) || !GlobalVariableCheck(LockNameLo()))
      return false;
   long hi = (long)GlobalVariableGet(LockNameHi());
   long lo = (long)GlobalVariableGet(LockNameLo());
   owner = (hi << 32) | (lo & 0xFFFFFFFF);
   return true;
  }

void LockWrite(const long chartId)
  {
   GlobalVariableSet(LockNameHi(), (double)((chartId >> 32) & 0xFFFFFFFF));
   GlobalVariableSet(LockNameLo(), (double)(chartId & 0xFFFFFFFF));
   GlobalVariableSet(LockNameHb(), (double)(long)TimeLocal());   // b22: heartbeat starts with the lock
   // b7: terminal globals live in memory and are only persisted to
   // gvariables.dat on graceful shutdown - a killed terminal loses them,
   // silently voiding the lock across crashes (verified live: kill test
   // 2026-07-13 showed a fresh acquire, no surviving lock). Flush makes
   // crash-recovery behavior deterministic.
   GlobalVariablesFlush();
  }

void LockDelete()
  {
   GlobalVariableDel(LockNameHi());
   GlobalVariableDel(LockNameLo());
   GlobalVariableDel(LockNameHb());   // b22: heartbeat dies with the lock
   GlobalVariablesFlush();   // b7: persist the release too - a crash after
                             // a graceful release must not resurrect the lock
  }

bool AcquireInstanceLock()
  {
   // Legacy-format cleanup (pre-b6 single double): unreadable reliably by
   // design of the bug it carried - remove it so it can never orphan again.
   if(GlobalVariableCheck(LockName()))
     {
      GlobalVariableDel(LockName());
      Log(LOG_INFO, "Legacy single-format instance lock found and removed (pre-b6) - superseded by HI/LO pair");
     }
   long owner = 0;
   if(LockOwner(owner))
     {
      if(owner != ChartID() && ChartGetInteger(owner, CHART_WINDOW_HANDLE, 0) != 0)
        {
         // b22 decision table: chart exists is no longer proof of life -
         // the heartbeat is (chart-alive/EA-dead hole, Stage 7 kill tests).
         long hbAge = LockHbAge();
         if(hbAge < 0)
           {
            // A6: legacy pre-b22 lock, no heartbeat. Conservative: the one
            // case we must never create is two live managers.
            Log(LOG_ERROR, StringFormat("Another TRTM holds a LEGACY lock (pre-b22, no heartbeat) for %s on chart %I64d - refusing. If that instance is dead: re-attach on its chart, or delete the TRTM_LOCK_%s globals (F3).",
                                        g_symbolNorm, owner, g_symbolNorm));
            return false;
           }
         if(hbAge < LOCK_HB_STALE_SEC)
           {
            // A4: owner alive. A7: a future stamp reads as age 0 - refuse,
            // but say the clock looks wrong.
            Log(LOG_ERROR, StringFormat("Another TRTM instance already manages %s on chart %I64d (heartbeat %ds ago%s) - refusing to run (one manager per symbol)",
                                        g_symbolNorm, owner, (int)hbAge,
                                        LockHbFuture() ? ", stamp is in the FUTURE - check terminal clock" : ""));
            return false;
           }
         // A5: chart survived but the EA is dead - take over.
         Log(LOG_WARN, StringFormat("Instance lock heartbeat dead for %ds (threshold %ds) on chart %I64d - owner presumed dead, taking over", (int)hbAge, LOCK_HB_STALE_SEC, owner));
        }
      else if(owner != ChartID())
         Log(LOG_WARN, "Stale instance lock found (previous chart gone) - taking over");
      else
         Log(LOG_INFO, "Instance lock re-asserted (own chart - e.g. parameter-change re-init)");
     }
   else
      Log(LOG_INFO, "Instance lock acquired (no existing lock)");   // b8: this path was
                     // silent, which made two kill-test outcomes ambiguous - every
                     // acquire branch now announces itself
   LockWrite(ChartID());
   return true;
  }

void ReleaseInstanceLock()
  {
   long owner = 0;
   if(!LockOwner(owner))
      return;   // no lock present - nothing to release
   if(owner != ChartID())
     {
      // Not ours: leave it, but say so (b6 - the b5 version skipped this
      // silently, which is how the orphaned lock went unnoticed).
      Log(LOG_WARN, StringFormat("Release: lock exists but not owned by this chart (owner %I64d) - leaving in place", owner));
      return;
     }
   LockDelete();
  }

//+------------------------------------------------------------------+
//| LIFECYCLE                                                        |
//+------------------------------------------------------------------+
int OnInit()
  {
   g_configBlocked = false;   // b17: globals survive param-change re-init - reset explicitly
   g_cfgReason     = "";
   g_symbolNorm = NormalizeSymbol(_Symbol);
   g_magic      = (InpMagicNumber > 0) ? InpMagicNumber : DeriveMagic(g_symbolNorm);
   g_stateFile  = TRTM_DIR_BASE + "state_" + g_symbolNorm + "_" + (string)g_magic + ".json";

   Log(LOG_INFO, StringFormat("=== TRTM %s init === symbol=%s (raw %s) magic=%d stateFile=%s",
                              TRTM_BUILD, g_symbolNorm, _Symbol, (int)g_magic, g_stateFile));

   if(!AcquireInstanceLock())
      return INIT_FAILED;
   g_fileLogEnabled = true;   // file logging is a privilege of the lock owner

   g_cfgCapture = true;
   bool cfgOK = ValidateInputs();
   g_cfgCapture = false;
   if(!cfgOK)
     {
      // b17 (Jeff, S6-1): stay attached, freeze everything, show the reason.
      g_configBlocked = true;
      Log(LOG_ERROR, "Input validation FAILED - CONFIG-BLOCKED: all trading frozen, buttons gray. Fix inputs (F7); reason on the dashboard warning row.");
      int liveN = 0;
      for(int i = 0; i < PositionsTotal(); i++)
        {
         ulong t = PositionGetTicket(i);
         if(t == 0) continue;
         if(PositionGetInteger(POSITION_MAGIC) == g_magic && PositionGetString(POSITION_SYMBOL) == _Symbol)
            liveN++;
        }
      if(liveN > 0)
        {
         Log(LOG_WARN, StringFormat("%d live position(s) with this magic are NOT being managed while config-blocked - no exits, no recovery, no adoption", liveN));
         NotifyMobile(StringFormat("CONFIG-BLOCKED with %d live position(s) UNMANAGED - no exits enforced. Fix the EA inputs.", liveN));   // b19
        }
      PanelCreate();
      EventSetMillisecondTimer(500);
      LogBrokerExitGeometry();   // b27: guidance is useful even while blocked
   Log(LOG_INFO, "Init complete - " + TRTM_BUILD + " CONFIG-BLOCKED (trading frozen)");
      return INIT_SUCCEEDED;
     }

   if(InpRunSelfTest && !RunStateSelfTest())
     {
      Log(LOG_ERROR, "Self-test failed - state persistence is broken on this terminal. EA will not run.");
      ReleaseInstanceLock();
      return INIT_FAILED;
     }

   Reconcile();

   // Stage 5: entry buttons are hard-disabled under Percentage Risk with
   // SL = 0 (locked rule; init already WARNed in ValidateInputs). Mobile
   // adoption stays possible - only the buttons are affected.
   g_entryEnabled = !(InpMoneyMode == MM_PERCENT_RISK && InpStopLossPts <= 0);

   PanelCreate();   // Stage 5: panel + dashboard (rebuilt fresh every init)

   // 500ms timer: dashboard refresh + confirm-window maintenance.
   EventSetMillisecondTimer(500);
   LogBrokerExitGeometry();   // b27: broker stops-level guidance for BE/trail config
   Log(LOG_INFO, "Init complete - " + TRTM_BUILD + (InpEnableRecovery
                  ? " (adoption, exits, recovery active)"
                  : " (adoption, exits active - recovery DISABLED)"));
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   PanelDestroy();   // Stage 5 / X1-X3: all TRTM_ objects removed; arm and
                     // placement-line state die with the instance (never persisted)
   g_pendDir  = 0;
   g_armState = ARM_NONE;
   if(g_state.levelCount > 0)
      StateSave(g_state);
   Log(LOG_INFO, StringFormat("Deinit (reason %d) - state %s", reason,
                              g_state.levelCount > 0 ? "saved (sequence alive)" : "clean (flat)"));
   ReleaseInstanceLock();
   if(g_logHandle != INVALID_HANDLE)
     {
      FileClose(g_logHandle);
      g_logHandle = INVALID_HANDLE;
     }
  }

// TPROBE3: the visual tester (build 5833, ButtonProbe evidence) delivers
// NO chart events but DOES toggle OBJPROP_STATE on click. Poll and
// dispatch. HandlePanelClick un-presses at its end, re-arming the button.
void TesterPollButtons()
  {
   static string btns[10] = {"B_BUY","B_SELL","B_CLOSE","B_PBUY","B_PSELL",
                             "B_PCONF","B_PCXL","B_CXLP","B_BE","B_TRAIL"};
   for(int i = 0; i < 10; i++)
     {
      string name = PNL + btns[i];
      if(ObjectFind(0, name) >= 0 &&
         (bool)ObjectGetInteger(0, name, OBJPROP_STATE))
        {
         Log(LOG_INFO, "TPROBE3: polled pressed state on " + btns[i] +
                       " - dispatching");
         HandlePanelClick(name);
        }
     }
  }

void OnTick()
  {
   if(MQLInfoInteger(MQL_TESTER))
      TesterPollButtons();
   if(g_configBlocked)
      return;   // b17: config-blocked = full trading freeze (adoption, exits, recovery)
   if(g_state.levelCount == 0)
     {
      CheckOwnPendingFillWhenFlat();   // Stage 5 / P5: our pending filled (or a
                                       // send survived a crash) -> register as L1
      if(g_state.levelCount == 0)
         TryAdopt();                   // Stage 2: flat -> look for a tagged L1
     }
   if(g_state.levelCount > 0)
     {
      CheckSequenceLiveness();  // Stage 2: tracked tickets still alive?
      if(g_state.levelCount > 0)
        {
         WatchDuplicateTags();  // Stage 2b2: warn on unmanaged duplicate L1 tags
         EnforceExits();        // Stage 3: TP/SL placement + policy-A enforcement
         EvaluateRecovery();    // Stage 4: interval tracking + recovery entries
        }
     }
  }

void OnTimer()
  {
   // b22 (B1-B3): heartbeat refresh - silent, every LOCK_HB_REFRESH_SEC.
   // Runs while CONFIG-BLOCKED too: blocked is not dead, and this instance
   // still owns the lock. Timer is terminal-driven, so weekends keep beating.
   static long s_lastHb = 0;
   long nowL = (long)TimeLocal();
   if(nowL - s_lastHb >= LOCK_HB_REFRESH_SEC)
     {
      s_lastHb = nowL;
      LockHbWrite();
     }
   NotifyFlush();   // b21: pushes queued during OnInit deliver from here
   // Stage 5: confirm-window expiry/invalidation first, then the dashboard
   // (so an expired arm never renders one more stale frame).
   ArmMaintain();
   PanelRefresh();
  }

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   // TPROBE2 telemetry: report EVERY event the tester delivers, so we can
   // see whether clicks arrive at all and which object they name.
   if(MQLInfoInteger(MQL_TESTER))
      Log(LOG_INFO, StringFormat("TPROBE2 event id=%d lparam=%I64d dparam=%.2f sparam='%s'",
                                 id, lparam, dparam, sparam));
   if(id == CHARTEVENT_OBJECT_CLICK && StringFind(sparam, PNL) == 0)
      HandlePanelClick(sparam);
  }

void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
   // Stage 3+: detect fills/closes affecting our magic, trigger
   // recompute + StateSave on every transition.
  }
//+------------------------------------------------------------------+