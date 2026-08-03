//+------------------------------------------------------------------+

void CheckRisk()
{
   double loss=
   ((StartBalance-AccountBalance())/StartBalance)*100;

   if(loss>=DailyLossLimit)
   {
      Comment(
      "XAU Risk Manager\n",
      "DAILY LOSS LIMIT REACHED\n",
      "Loss: ",
      DoubleToString(loss,2),
      "%"
      );
   }
}
