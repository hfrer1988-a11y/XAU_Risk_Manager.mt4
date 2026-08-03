//+------------------------------------------------------------------+
//| XAU_Risk_Manager.mq4                                             |
//| Risk Management EA for MT4                                       |
//+------------------------------------------------------------------+

#property strict

input double RiskPercent = 1.0;
input int MaxOpenTrades = 3;
input double DailyLossLimit = 3.0;

string PanelName="XAU_RISK_PANEL";

double StartBalance;


//+------------------------------------------------------------------+

int OnInit()
{
   StartBalance=AccountBalance();

   CreatePanel();

   return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+

void OnDeinit(const int reason)
{
   DeletePanel();
}


//+------------------------------------------------------------------+

void OnTick()
{
   UpdatePanel();
   CheckRisk();
}


//+------------------------------------------------------------------+

void CreatePanel()
{
   ObjectCreate(0,PanelName,OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,PanelName,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,PanelName,OBJPROP_XDISTANCE,10);
   ObjectSetInteger(0,PanelName,OBJPROP_YDISTANCE,20);

   ObjectSetString(0,PanelName,OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,PanelName,OBJPROP_FONTSIZE,12);
}


//+------------------------------------------------------------------+

void UpdatePanel()
{
   int trades=0;

   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderSymbol()==Symbol())
            trades++;
      }
   }


   double loss=
   ((StartBalance-AccountBalance())/StartBalance)*100;


   string text;

   text=
   "XAU Risk Manager\n"
   +"----------------\n"
   +"Balance: "+DoubleToString(AccountBalance(),2)+"\n"
   +"Equity: "+DoubleToString(AccountEquity(),2)+"\n"
   +"Risk: "+DoubleToString(RiskPercent,1)+"%\n"
   +"Trades: "+IntegerToString(trades)+"\n"
   +"Daily Loss: "+DoubleToString(loss,2)+"%";


   ObjectSetString(0,PanelName,OBJPROP_TEXT,text);
}


//+------------------------------------------------------------------+

void DeletePanel()
{
   ObjectDelete(0,PanelName);
}
