//+------------------------------------------------------------------+
//|                                              New_Model_Maker.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//------------------------------------------------------------------------------------------
//Notes:
//DeltaDiscreteModelMaker is the same as CharlieDiscreteModelMaker except it only holds an
//order open for a set amount of bars.
//
//------------------------------------------------------------------------------------------






extern int Long_Back_1;
extern int Long_Back_2;
extern int Short_Back_1;
extern int Short_Back_2;
extern int Open_Bars;



int ticket;
extern double Lots = 0.01;
int Magic = 200;
bool LongCond = false;
bool ShortCond = false;
bool ExitLongCond = false;
bool ExitShortCond = false;

bool first_pass = true;

int open_bars = 0;

void OnTick(){
   
   
   bool New_Bar = Find_New_Bar();
      
   if(New_Bar&&!first_pass&&((Long_Back_1!=Long_Back_2)||(Short_Back_1!=Short_Back_2))){
      
      
      LongCond = false;
      ShortCond = false;
      
      if(Open[Long_Back_1] > Open[Long_Back_2]){
         LongCond = true;
      }
      
      if(Open[Short_Back_1] > Open[Short_Back_2]){
         ShortCond = true;
      }
      
      if(LongCond&&!ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
      }
      
      if(!LongCond&&ShortCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,10,NULL,NULL,"Short Here",Magic,0,0);
      }
      
      if(CheckOpenOrders()){
         open_bars++;
      }
      
      bool lovely = OrderSelect(ticket, SELECT_BY_TICKET);
      int type = OrderType();//0 = BUY ORDER, 1 = SELL ORDER
      
      if(type==0&&open_bars==Open_Bars){
         bool closer = OrderClose(ticket,Lots,Bid,10,0);
         open_bars = 0;
      }
      
      if(type==1&&open_bars==Open_Bars){
         bool closer = OrderClose(ticket,Lots,Ask,10,0);
         open_bars = 0;
      }
      
   }
   
   if(first_pass){first_pass=false;}
}



bool CheckOpenOrders(){
   for( int i = 0 ; i < OrdersTotal() ; i++ ) {
      bool a = OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
      if( OrderSymbol() == Symbol() && OrderMagicNumber() == Magic ) 
         return(true);
   }
   return(false);
}

// Identify new bars
bool Find_New_Bar(){
   static datetime New_Time = 0;
   bool New_Bar_local = false;
   if (New_Time!= Time[0]){
      New_Time = Time[0];
      New_Bar_local = true;
      }
   return(New_Bar_local);
}