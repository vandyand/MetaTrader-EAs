//+------------------------------------------------------------------+
//|                                                 SimpleSystem.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int    StartHour = 9;
extern int    TakeProfit = 40;
extern int    StopLoss = 40;
extern double Lots = 1;
extern int    MA_Period = 100;


void OnTick()//loops on tick
  {
   //First code the blue part
   
   static bool IsFirstTick = true; //static bool basically means global. It doesn't reinitaillize to true every loop of OnTick
   int ticket = 0;
   
   double ma = iMA(Symbol(),Period(),MA_Period,0,0,0,1);//moving average
   
   if(Hour() == StartHour){
      if(IsFirstTick == true){
         IsFirstTick = false;
         
         //Red part of code
         
         
         bool res;
         res = OrderSelect(ticket, SELECT_BY_TICKET);
         if(res == true){
            if(OrderCloseTime() == 0){//if order hasn't been closed
               bool res2;
               res2 = OrderClose(ticket, Lots, OrderClosePrice(), 10);
               if(res2 = false){
                  Alert("Error closing order #", ticket);
               }
            }
         }
         
         //Body of the executive assistant (Green part)
         
         if(Open[0] < Open[StartHour]){ //Open[], Close[], High[], Low[], are arrays. We specify the candle we want to get data from.
                   //Candles are always numbered from right to left starting at zero (current candle)
                   //So we want to compair our 9th hour open price Open[0], with start hour open Open[StartHour].
            //Check ma
            if(Close[1] < ma){
               ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Bid-StopLoss*Point*10, Bid+TakeProfit*Point*10, "Set by SimpleSystem");//Here's where the order is sent
               if(ticket < 0){
                  Alert("Error sending order!");
               }
            }
         }
         else{
            //check ma
            if(Close[1] > ma){
               ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Ask+StopLoss*Point*10, Ask-TakeProfit*Point*10, "Set by SimpleSystem");//Here's where the order is sent
               if(ticket < 0){
                  Alert("Error sending order!");
               }
            }
         }
         
      }
   }
   else{
      IsFirstTick = true;
   }
  }