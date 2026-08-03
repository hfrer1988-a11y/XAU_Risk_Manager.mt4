//+------------------------------------------------------------------+
//| XAU_Risk_Manager.mq4                                             |
//| MT4 Gold Risk Manager                                            |
//+------------------------------------------------------------------+

#property strict

input double RiskPercent = 1.0;
input double DailyLossLimit = 3.0;

double StartBalance;

string Panel="XAU_PANEL";
string CloseButton="CLOSE_ALL";


//+------------------------------------------------------------------+
int OnInit()
{
   StartBalance = AccountBalance();

   ObjectCreate(0,Panel,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,Panel,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,Panel,OBJPROP_XDISTANCE,10);
   ObjectSetInteger(0,Panel,OBJPROP_YDISTANCE,20);
   ObjectSetInteger(0,Panel,OBJPROP_FONTSIZE,12);


   ObjectCreate(0,CloseButton,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,CloseButton,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,CloseButton,OBJPROP_XDISTANCE,10);
   ObjectSetInteger(0,CloseButton,OBJPROP_YDISTANCE,120);
   ObjectSetInteger(0,CloseButton,OBJPROP_XSIZE,100);
   ObjectSetInteger(0,CloseButton,OBJPROP_YSIZE,25);
   ObjectSetString(0,CloseButton,OBJPROP_TEXT,"Close All");


   return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectDelete(0,Panel);
   ObjectDelete(0,CloseButton);
}


//+------------------------------------------------------------------+
void OnTick()
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


   double loss =
   ((StartBalance-AccountBalance())/StartBalance)*100;


   string text =
   "XAU Risk Manager\n"
   "----------------\n"
   "Balance: "+DoubleToString(AccountBalance(),2)+"\n"
   "Equity: "+DoubleToString(AccountEquity(),2)+"\n"
   "Risk: "+DoubleToString(RiskPercent,1)+"%\n"
   "Trades: "+IntegerToString(trades)+"\n"
   "Loss: "+DoubleToString(loss,2)+"%";


   ObjectSetString(0,Panel,OBJPROP_TEXT,text);


   if(loss>=DailyLossLimit)
   {
      Comment(
      "DAILY LOSS LIMIT REACHED\n",
      DoubleToString(loss,2),
      "%"
      );
   }
}


//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id==CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam==CloseButton)
      {
         CloseAll();
      }
   }
}


//+------------------------------------------------------------------+
void CloseAll()
{
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderSymbol()==Symbol())
         {
            if(OrderType()==OP_BUY)
               OrderClose(OrderTicket(),OrderLots(),Bid,5);

            if(OrderType()==OP_SELL)
               OrderClose(OrderTicket(),OrderLots(),Ask,5);
         }
      }
   }
}
//+------------------------------------------------------------------+
