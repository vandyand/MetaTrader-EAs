//+------------------------------------------------------------------+
//|                                                Datetime_test.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern datetime Datetime = D'2017.10.03 12:00:00';

void OnTick(){
   
   
   Datetime++;
   Alert(Datetime);
   
}