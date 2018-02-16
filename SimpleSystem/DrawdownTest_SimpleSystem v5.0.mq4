//+------------------------------------------------------------------+
//|                                                 SimpleSystem.mq4 |
//|                                        Copyright 2014, ForexBoat |
//|                                         http://www.forexboat.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, ForexBoat"
#property link      "http://www.forexboat.com"
#property version   "1.00"
#property strict

extern int     StartHour      = 9; 
extern int     MinPipLimit    = 0; 
extern int     TakeProfit     = 40; 
extern int     StopLoss       = 40; 
extern double  Lots           = 1;
extern bool    UseMAFilter    = false;
extern int     MA_Period      = 100;

int Magic = 50262802;

void OnTick()
{
   static bool IsFirstTick = true;
   static int  ticket = 0;
   
   double ma = iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
   
   if(Hour() == StartHour)
   {
      if(IsFirstTick == true)
      {
         IsFirstTick = false;
      
         //FindTicket makes sure that the EA will pick up its orders
         //even if it is relaunched
         ticket = FindTicket(Magic);         
            
         bool res;
         res = OrderSelect(ticket, SELECT_BY_TICKET);
         if(res == true)
         {
            if(OrderCloseTime() == 0)
            {
               bool res2;
               res2 = OrderClose(ticket, Lots, OrderClosePrice(), 10);
               
               if(res2 == false)
               {
                  Alert("Error Closing Order #", ticket);
               }
            } 
         }
      
         if(Open[0] < Open[StartHour] - MinPipLimit*Point) //v3.0
         {
            //check ma
            if(Close[1] < ma || UseMAFilter == false) //v3.0
            {
               ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  Alert("Error Sending Order!");
               }
            }
         }
         else if(Open[0] > Open[StartHour] + MinPipLimit*Point) //v3.0
         {
            //check ma
            if(Close[1] > ma || UseMAFilter == false) //v3.0
            {
               ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point, Ask-TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  Alert("Error Sending Order!");
               }
            }
         }

      }
   }
   else
   {
      IsFirstTick = true;
   }

}

double OnTester(){
   
   
   double drawdown = get_drawdown(30,"fore");
   
   return(drawdown);
}


int FindTicket(int M)
{
   int ret = 0;
   
   for(int i = OrdersTotal()-1; i >= 0; i--)
   {
      bool res;
      res = OrderSelect(i, SELECT_BY_POS);
      if(res == true)
      {
         if(OrderMagicNumber() == M)
         {
            ret = OrderTicket();
            break;
         }
      }
   }
   
   return(ret);
}

double get_drawdown(int firstftrade_, string bf){
   
   if(OrdersHistoryTotal()<=1){
      return(0);
   }
   
   int num_orders = 0;
   int strt = 0;
   int end = 0;
   
   if(bf=="back"){
      strt = OrdersHistoryTotal()-1;
      end = firstftrade_;
      num_orders = OrdersHistoryTotal()-firstftrade_-1;
   }
   else if(bf=="fore"){
      strt = firstftrade_;
      end = -1;
      num_orders = firstftrade_ + 1;
   }
   else if(bf=="none"){
      strt = OrdersHistoryTotal()-1;
      end = -1;
      num_orders = OrdersHistoryTotal();
   }
   else{return(-1);}
   
   double local_drawdown = 0;
   double max_drawdown = 0;
   double high_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   double local_low_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   double curr_bal = TesterStatistics(STAT_INITIAL_DEPOSIT);
   
   for(int i = strt; i > end; --i){
      bool ddres = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      curr_bal += OrderProfit();
      if(curr_bal > high_bal){
         high_bal = curr_bal;
         local_low_bal = curr_bal;
      }
      if(curr_bal < local_low_bal){
         local_low_bal = curr_bal;
      }
      local_drawdown = high_bal - local_low_bal;
      if(local_drawdown > max_drawdown){
         max_drawdown = local_drawdown;
      }
   }
   return(max_drawdown);
}