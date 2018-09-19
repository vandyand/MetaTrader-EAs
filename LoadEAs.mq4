//+------------------------------------------------------------------+
//|                                                      LoadEAs.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs //This property makes the input screen show up
                      //when it's started.
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

extern int num_EAs = 0;
extern string symbol = "EURUSD";
extern ENUM_TIMEFRAMES timeframe = PERIOD_H1; 

void OnStart(){   
   long ID = 0;
   string tpl_names[];
   ArrayResize(tpl_names,num_EAs);
   
   for(int i=0;i<num_EAs;i++){
      ID = ChartOpen(symbol,timeframe);
      ChartApplyTemplate(ID,"tpl"+string(i+1)+".tpl");
   }
}