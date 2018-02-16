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
extern bool    UseKC             = false; //If you use Kelly Criterion the "Lots" variable is overwritten with optimal value.
extern double  KCWinPct          = 0.05;
extern double  KCSize            = 0.5;
extern bool    UseMAFilter       = false;
extern int     MA_Period         = 100;
extern int     Magic             = 59789101;
extern bool    MarketExecution   = false;
extern bool    UseTrailingSL     = false;
extern int     TrailValue        = 40;

void OnTick()
{
   static bool IsFirstTick = true;
   static int  ticket = 0;
   string comment;
   
   double RiskPct = KellyCriterion(KCWinPct, TakeProfit, StopLoss);
   double TradeSizeUSD = RiskPct * AccountBalance();
   
   if(UseKC == true){
      //if(Hour() == StartHour){printf(RiskPct);}
      double val = TradeSizeUSD/(2000*Ask)*KCSize;
      Lots = ((int)(val * 100 + 0.5)/100.0);
      
   }
   
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

      if(UseTrailingSL == true) //execute trailing stop - this has to be done on every tick
      {
         //FindTicket makes sure that the EA will pick up its orders
         //even if it is relaunched
         int ticket_trailing = FindTicket(Magic);  
         
         if(ticket_trailing > 0)
         {
            TrailingStop(ticket_trailing);      
         }
      }
   }

}

/*
   -------------------------------
         Auxiliary Functions     
   -------------------------------
*/

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

void TrailingStop(int ticket)                                                 
{
   bool res;                                                                  
   res = OrderSelect(ticket, SELECT_BY_TICKET);                               
   
   if(res == true)
   {
      if(OrderType() == OP_BUY)   
      {                                            
         if(Bid - OrderStopLoss() > TrailValue*Point)    //adjust stop loss if it is too far                           
         {
            res = OrderModify(OrderTicket(), 0, Bid - TrailValue*Point, OrderTakeProfit(), 0); 
            if(!res)
            {
               Alert("TrailingStop OrderModify Error: ", GetLastError());  
            }
        }
      }
         
      if(OrderType() == OP_SELL)
      {
         if(OrderStopLoss() - Ask > TrailValue*Point)    //adjust stop loss if it is too far  
         {
            res = OrderModify(OrderTicket(), 0, Ask + TrailValue*Point, OrderTakeProfit(), 0);        
            if(!res)
            {
               Alert("TrailingStop OrderModify Error: ", GetLastError());  
            }
         }
      }
   }
}


double KellyCriterion(double WinPercent, double TP, double SL){
   //K = (PB-(1-P))/B, K = % of account to risk per trade, P = win percentage historically, B = payout ratio (TP:SL)
   double P = WinPercent;
   double B = TP/SL;
   double K = (P*B-(1-P))/B;
   return(K);
}