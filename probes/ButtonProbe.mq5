//+------------------------------------------------------------------+
//| ButtonProbe.mq5 - diagnostic only, NOT part of the TRTM chain.   |
//| Maps which input channels the visual tester actually delivers:   |
//|   A) CHARTEVENT_OBJECT_CLICK on a plain OBJ_BUTTON               |
//|   B) OBJPROP_STATE toggling (pollable from OnTick)               |
//|   C) CHARTEVENT_MOUSE_MOVE / mouse-down (manual hit-testing)     |
//|   D) CHARTEVENT_CLICK (bare chart click)                         |
//| One run + a few clicks = complete channel map.                   |
//+------------------------------------------------------------------+
#property strict
#property version "1.0"

bool g_lastState = false;

int OnInit()
  {
   ObjectCreate(0, "BP_BTN", OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, "BP_BTN", OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, "BP_BTN", OBJPROP_XDISTANCE, 30);
   ObjectSetInteger(0, "BP_BTN", OBJPROP_YDISTANCE, 60);
   ObjectSetInteger(0, "BP_BTN", OBJPROP_XSIZE, 160);
   ObjectSetInteger(0, "BP_BTN", OBJPROP_YSIZE, 40);
   ObjectSetString (0, "BP_BTN", OBJPROP_TEXT, "CLICK ME");
   ObjectSetInteger(0, "BP_BTN", OBJPROP_FONTSIZE, 12);
   // Deliberately: no OBJPROP_HIDDEN, no OBJPROP_SELECTABLE overrides,
   // no other objects on the chart. Bare defaults.
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);   // enable channel C
   Print("[PROBE] init ok - tester=", (string)MQLInfoInteger(MQL_TESTER),
         " visual=", (string)MQLInfoInteger(MQL_VISUAL_MODE));
   ChartRedraw(0);
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   ObjectDelete(0, "BP_BTN");
  }

void OnTick()
  {
   // Channel B: poll button state every tick.
   bool st = (bool)ObjectGetInteger(0, "BP_BTN", OBJPROP_STATE);
   if(st != g_lastState)
     {
      Print("[PROBE] B: OBJPROP_STATE changed -> ", (string)st,
            " (polling channel WORKS)");
      g_lastState = st;
      if(st)
         ObjectSetInteger(0, "BP_BTN", OBJPROP_STATE, false); // re-arm
     }
  }

void OnChartEvent(const int id, const long &lparam, const double &dparam,
                  const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK)
      Print("[PROBE] A: OBJECT_CLICK on '", sparam, "' (event channel WORKS)");
   else if(id == CHARTEVENT_CLICK)
      Print("[PROBE] D: bare chart click x=", (string)lparam,
            " y=", DoubleToString(dparam, 0));
   else if(id == CHARTEVENT_MOUSE_MOVE)
     {
      // sparam = button-state flags; log only transitions with left button
      // down to avoid per-pixel spam.
      static int lastFlags = 0;
      int flags = (int)StringToInteger(sparam);
      if(((flags & 1) != 0) && ((lastFlags & 1) == 0))
         Print("[PROBE] C: mouse LEFT-DOWN at x=", (string)lparam,
               " y=", DoubleToString(dparam, 0), " (mouse channel WORKS)");
      lastFlags = flags;
     }
   else
      Print("[PROBE] other event id=", (string)id, " sparam='", sparam, "'");
  }
//+------------------------------------------------------------------+
