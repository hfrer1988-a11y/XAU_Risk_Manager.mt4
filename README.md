# XAU_Risk_Manager.mt4
//+------------------------------------------------------------------+
//| XAU_Risk_Manager.mq4                                              |
//| MT4 Risk Management Expert Advisor                                |
//+------------------------------------------------------------------+

#property strict

input double RiskPercent = 1.0;       // Risk per trade %
input int MaxOpenTrades = 3;          // Maximum open trades
input double DailyLossLimit = 3.0;    // Daily loss limit %

input int StopLossPoints = 500;        // Stop loss points

double StartBalance;

//+------------------------------------------------------------------+
int OnInit()
{
   StartBalance = AccountBalance();

   Comment(
   "XAU Risk Manager\n",
   "Risk: ",RiskPercent,"%\n",
   "Max Trades: ",MaxOpenTrades,"\n",
   "Daily Loss: ",DailyLossLimit,"%"
   );

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
void OnTick()
{
   CheckDailyLoss();
   CheckTradeLimit();
}

//+------------------------------------------------------------------+

void CheckTradeLimit()
{
   int count=0;

   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         if(OrderSymbol()==Symbol())
            count++;
      }
   }

   if(count>=MaxOpenTrades)
   {
      Comment(
      "XAU Risk Manager\n",
      "Trading blocked\n",
      "Max trades reached: ",
      MaxOpenTrades
      );
   }
}

//+------------------------------------------------------------------+

void CheckDailyLoss()
{
   double lossPercent=
   ((StartBalance-AccountBalance())/StartBalance)*100;

   if(lossPercent>=DailyLossLimit)
   {
      Comment(
      "XAU Risk Manager\n",
      "Daily loss limit reached\n",
      lossPercent,"%"
      );
   }
}

//+------------------------------------------------------------------+

double CalculateLot()
{
   double riskMoney=
   AccountBalance()*RiskPercent/100;

   double tickValue=
   MarketInfo(Symbol(),MODE_TICKVALUE);

   double lot=
   riskMoney/(StopLossPoints*tickValue);

   lot=NormalizeDouble(lot,2);

   if(lot<0.01)
      lot=0.01;

   return(lot);
}

//+------------------------------------------------------------------+
