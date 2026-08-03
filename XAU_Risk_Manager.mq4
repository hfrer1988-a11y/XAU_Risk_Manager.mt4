//+------------------------------------------------------------------+
//| XAU_Risk_Manager_V2.mq4                                          |
//+------------------------------------------------------------------+

#property strict

input double RiskPercent = 1.0;
input double DailyLossLimit = 3.0;
input bool EnableRiskLock = true;
input int MaxOpenTrades = 3;

double StartBalance;

string Panel="XAU_PANEL_V2";
string CloseButton="CLOSE_ALL_V2";


//+------------------------------------------------------------------+
int OnInit()
{
   StartBalance=AccountBalance();

   ObjectDelete(0,Panel);
   ObjectDelete(0,CloseButton);


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

   double loss=
   ((StartBalance-AccountBalance())/StartBalance)*100;


   int trades=0;

   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderSymbol()==Symbol())
            trades++;
      }
   }


   string status="NORMAL";


   if(EnableRiskLock && loss>=DailyLossLimit)
   {
      status="RISK LOCKED";
   }


   if(trades>=MaxOpenTrades)
   {
      status="MAX TRADES";
   }


   string txt=
   "XAU Risk Manager V2\n"
   "----------------\n"
   "Balance: "+DoubleToString(AccountBalance(),2)+"\n"
   "Equity: "+DoubleToString(AccountEquity(),2)+"\n"
   "Trades: "+IntegerToString(trades)+"/"+IntegerToString(MaxOpenTrades)+"\n"
   "Loss: "+DoubleToString(loss,2)+"%\n"
   "Status: "+status;


   ObjectSetString(0,Panel,OBJPROP_TEXT,txt);

}//+------------------------------------------------------------------+

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
            {
               OrderClose(
               OrderTicket(),
               OrderLots(),
               Bid,
               5
               );
            }


            if(OrderType()==OP_SELL)
            {
               OrderClose(
               OrderTicket(),
               OrderLots(),
               Ask,
               5
               );
            }

         }
      }
   }
}

//+------------------------------------------------------------------+
