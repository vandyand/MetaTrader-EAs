//+------------------------------------------------------------------+
//|                                                  5MinScalper.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern bool inside = true;
extern int BBPeriod = 25;
extern double BBStdDev = 3;
//extern double CloseDistFromMA = 2.5;
extern bool UseSL = true;
//extern int SLDistSpread = 5;
extern int StopLoss = 1000;
//extern bool UseADX = true;
extern int ADXMethod = 0;
extern int ADXLevel = 25;
extern int ADXRange = 0;
extern double Lots = 1;
//extern bool UsePct = false;
//extern double RiskPct = 0.1;
extern int Magic = 3755;

int ticket;
//double Lots;
string comment = " ";

bool BuyCond = false;
bool SellCond = false;
bool ExitCond = false;

//ADX indicator parameters
int timeframe = 0; //0 means current chart.
int ADXPeriod = BBPeriod;//Could experiment here
bool ADXFilter = false;
bool adxbuycond = false;
bool adxsellcond = false;

bool FirstTickofHour = false;

void OnTick(){
   
   
   bool New_Bart = Fun_New_Bar();
   
   if (New_Bart){
      //Alert("This is the new bar");   
      
      
      double bb_main = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, 1, MODE_MAIN, 0);
      double bb_upper = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, 1, MODE_UPPER, 0);
      double bb_lower = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, 1, MODE_LOWER, 0);
      
      OrderSelect(0,SELECT_BY_POS);
   
      double ADX_Main = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MAIN, 0);
      double ADX_PlusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_PLUSDI, 0);
      double ADX_MinusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MINUSDI, 0);
      
      //ADXFilter Method options: 0; no ADXMethod, 1; adxmain>level, 2; adxmain<level, 3; adxrangelow<level<adxrangehigh
      //4;buy only when +di>-di && sell only when -di>+di, 5; buy only when -di>+di && sell only when +di>-di;
      if(ADXMethod == 0){ADXFilter = true;adxbuycond=true;adxsellcond=true;}
      if(ADXMethod == 1){
         if(ADX_Main>ADXLevel){ADXFilter = true;adxbuycond=true;adxsellcond=true;}
         else{ADXFilter = false;}
      }
      if(ADXMethod == 2){
         if(ADX_Main<ADXLevel){ADXFilter = true;adxbuycond=true;adxsellcond=true;}
         else{ADXFilter = false;}
      }
      if(ADXMethod == 3){
         if(ADXLevel-ADXRange<ADX_Main && ADXLevel>ADX_Main){ADXFilter = true;adxbuycond=true;adxsellcond=true;}
         else{ADXFilter = false;}
      }
      if(ADXMethod == 4){
         if(ADX_PlusDI>ADX_MinusDI){ADXFilter=true; adxbuycond=true; adxsellcond=false;}
         else if(ADX_MinusDI>ADX_PlusDI){ADXFilter=true; adxbuycond=false; adxsellcond=true;}
         else{ADXFilter=false;adxbuycond=false;adxsellcond=false;}
      }
      if(ADXMethod == 5){
         if(ADX_PlusDI>ADX_MinusDI){ADXFilter=true; adxbuycond=false; adxsellcond=true;}
         else if(ADX_MinusDI>ADX_PlusDI){ADXFilter=true; adxbuycond=true; adxsellcond=false;}
         else{ADXFilter=false;adxbuycond=false;adxsellcond=false;}
      }      
      
      //Enter and exit trade conditions
      if(Open[0]<bb_lower&&!CheckOpenOrders()&&ADXFilter&&((inside&&adxbuycond)||(!inside&&adxsellcond))){BuyCond=true;}
      else{BuyCond=false;}
      
      if(Open[0]>bb_upper&&!CheckOpenOrders()&&ADXFilter&&((inside&&adxsellcond)||(!inside&&adxbuycond))){SellCond=true;}
      else{SellCond=false;}
      
      //(Bid-0.0005<bb_main&&bb_main<Ask+0.0005)
      if(((inside&&((OrderType()==0&&Open[0]>bb_main)||(OrderType()==1&&Open[0]<bb_main)))
         ||(!inside&&((OrderType()==0&&Open[0]<bb_main)||(OrderType()==1&&Open[0]>bb_main))))
         &&CheckOpenOrders()){ExitCond=true;}
      else{ExitCond=false;}
      
      
      
      
      /*
      if(UsePct==true){
      double val = AccountBalance()*RiskPct/(2000*(Bid+0.5*(Ask-Bid)));
      Lots = ((int)(val * 100 + 0.5)/100.0);
      }
      else{Lots = 1;}
      */
      
      if((inside&&BuyCond)||(!inside&&SellCond)){
        //Buy!
        if(UseSL==true){ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Ask-StopLoss*Point, NULL, "Set by BBEA", Magic);}
        else{ticket = OrderSend(Symbol(),OP_BUY, Lots, Ask, 10, NULL, NULL, "Set by BBEA", Magic);}
        if(ticket < 0){comment = comment + " " + "Error Sending BUY Order dude!";}
        else{comment = comment + " " + "BUY Order Succesfuly Sent dude!";}
        Alert("Buy Ticket # is: " + ticket);
      }
      
      
      if((inside&&SellCond)||(!inside&&BuyCond)){
        //Sell!
        if(UseSL==true){ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, Bid+StopLoss*Point, NULL, "Set by BBEA", Magic);}
        else{ticket = OrderSend(Symbol(), OP_SELL, Lots, Bid, 10, NULL, NULL, "Set by BBEA", Magic);}
        if(ticket < 0){comment = comment + " " + "Error Sending SELL Order bro!";}
        else{comment = comment + " " + "SELL Order Succesfuly Sent bro!";}
        Alert("Sell Ticket # is: " + ticket);
      }
      
      
      int result;
      
         
      if(ExitCond){
        //Exit!
        result = OrderClose(ticket, Lots, Bid, 30);
        if(result == false){comment = comment + " Error closing order!-Tried to close bc price hit MABig bro!";}
        else{comment = comment + " Order Closed because price hit MABig bro!";}
        Alert("Attempting to Exit Order");
      }
   }
}

//True if there are current open orders for the symbol made by this ea.
bool CheckOpenOrders(){
for( int i = 0 ; i < OrdersTotal() ; i++ ) {
   bool apo493QsW8 = OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
      if( OrderSymbol() == Symbol() && OrderMagicNumber() == Magic ) return(true);
   }
return(false);
}



// Identify new bars
bool Fun_New_Bar()
   {
   static datetime New_Time = 0;
   bool New_Bar = false;
   if (New_Time!= Time[0])
      {
      New_Time = Time[0];
      New_Bar = true;
      }
   return(New_Bar);
   }