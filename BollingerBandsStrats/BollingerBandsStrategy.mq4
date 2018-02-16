//+------------------------------------------------------------------+
//|                                                  5MinScalper.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


extern int BBPeriod = 25;
extern double BBStdDev = 3;
//extern double CloseDistFromMA = 2.5;
extern bool UseSL = true;
//extern int SLDistSpread = 5;
extern int StopLoss = 1000;
extern bool UseADX = true;
extern double ADXLevel = 25;
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
int period = 10;

void OnTick(){
   
   
   double bb_main = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, 1, MODE_MAIN, 0);
   double bb_upper = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, 1, MODE_UPPER, 0);
   double bb_lower = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, 1, MODE_LOWER, 0);
   
   OrderSelect(0,SELECT_BY_POS);

   double ADX_Main = iADX(Symbol(), 0, period, PRICE_OPEN, MODE_MAIN, 0);
   
   if(Bid+(0.5*Ask-0.5*Bid)<bb_lower&&CheckOpenOrders()==false&&ADX_Main>ADXLevel){BuyCond=true;}
   else{BuyCond=false;}
   
   if(Bid+(0.5*Ask-0.5*Bid)>bb_upper&&CheckOpenOrders()==false&&ADX_Main>ADXLevel){SellCond=true;}
   else{SellCond=false;}
   
   //(Bid-0.0005<bb_main&&bb_main<Ask+0.0005)
   if(((OrderType()==0&&Ask<bb_main)||(OrderType()==1&&Bid>bb_main))&&CheckOpenOrders()==true){ExitCond=true;}
   else{ExitCond=false;}
   
   /*
   if(UsePct==true){
   double val = AccountBalance()*RiskPct/(2000*(Bid+0.5*(Ask-Bid)));
   Lots = ((int)(val * 100 + 0.5)/100.0);
   }
   else{Lots = 1;}
   */
   
   if(SellCond){
     //Buy!
     if(UseSL==true){ticket = OrderSend(Symbol(), OP_BUY, Lots, Ask, 10, Ask-StopLoss*Point, NULL, "Set by BBEA", Magic);}
     else{ticket = OrderSend(Symbol(),OP_BUY, Lots, Ask, 10, NULL, NULL, "Set by BBEA", Magic);}
     if(ticket < 0){comment = comment + " " + "Error Sending BUY Order dude!";}
     else{comment = comment + " " + "BUY Order Succesfuly Sent dude!";}
     Alert("Buy Ticket # is: " + ticket);
   }
   
   
   if(BuyCond){
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

//True if there are current open orders for the symbol made by this ea.
bool CheckOpenOrders(){
for( int i = 0 ; i < OrdersTotal() ; i++ ) {
   bool apo493QsW8 = OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
      if( OrderSymbol() == Symbol() && OrderMagicNumber() == Magic ) return(true);
   }
return(false);
}


