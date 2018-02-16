//+------------------------------------------------------------------+
//|                                                 SimpleSystem.mq4 |
//|                                        Copyright 2014, ForexBoat |
//|                                         http://www.forexboat.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, ForexBoat"
#property link      "http://www.forexboat.com"
#property version   "1.00"
#property strict

extern int     StartHour         = 9; 
extern int     MinPipLimit       = 0; 
extern int     TakeProfit        = 40; 
extern int     StopLoss          = 40; 
extern double  Lots              = 1;
extern bool    UseMAFilter       = false;
extern int     MA_Period         = 100;
extern int     Magic             = 59789101;
extern bool    MarketExecution   = false;

void OnTick()
{
   static bool IsFirstTick = true;
   static int  ticket = 0;
   string comment;
   
   double ma = iMA(Symbol(), Period(), MA_Period, 0, 0, 0, 1);
   
   if(Hour() == StartHour)
   {
      comment = GetDateAndTime();
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
               ticket = MarketOrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point, Bid+TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  comment = comment + " " + "Error Sending BUY Order";
               }
               else
               {
                  comment = comment + " " + "BUY Order Succesfuly Sent";
               }               
            }
            else
            {
               comment = comment + " " + "MA Check Not Passed";
            }
         }
         else if(Open[0] > Open[StartHour] + MinPipLimit*Point) //v3.0
         {
            //check ma
            if(Close[1] > ma || UseMAFilter == false) //v3.0
            {
               ticket = MarketOrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point, Ask-TakeProfit*Point, "Set by SimpleSystem", Magic);
               if(ticket < 0)
               {
                  comment = comment + " " + "Error Sending SELL Order";
               }
               else
               {
                  comment = comment + " " + "SELL Order Succesfuly Sent";
               }                  
            }
            else
            {
               comment = comment + " " + "MA Check Not Passed";
            }
         }
         else
         {
            comment = comment + " " + "MinPipLimit Check Not Passed";
         }

      }
      Comment(comment);
      Print(comment);
   }
   else
   {
      IsFirstTick = true;
   }

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

string GetDateAndTime()
{
   return( string(Year())+"-"+StringFormat("%02d",Month())+"-"+StringFormat("%02d",Day())+" "+StringFormat("%02d",Hour())+":"+StringFormat("%02d",Minute()));
}

int MarketOrderSend(string symbol, int cmd, double volume, double price, int slippage, double stoploss, double takeprofit, string comment, int magic)
{
   int ticket;
   
   if(MarketExecution == false)
   {
      ticket = OrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic);
      if(ticket <= 0) Alert("OrderSend Error: ", GetLastError());
      return(ticket);         
   }
   else
   {
      ticket = OrderSend(symbol, cmd, volume, price, slippage, 0, 0, comment, magic);
      if(ticket <= 0) Alert("OrderSend Error: ", GetLastError());
      else
      {
         bool res = OrderModify(ticket, 0, stoploss, takeprofit, 0);
         if(!res) {  Alert("OrderModify Error: ", GetLastError());
                     Alert("!!! ORDER #", ticket, " HAS NO STOPLOSS AND TAKEPROFIT --- ORDER MODIFY ERROR: GetLastError()");}
      }
      return(ticket);
   }
}