//+------------------------------------------------------------------+
//|                                              New_Model_Maker.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int iterater = 0;
int num_total_rows = 0;
int num_unique_rows = 0;
int num_redundant_rows = 0;
extern int num_input_types = 40;
extern int num_comparers = 2;
int num_comparisons = 0;
string unique_table[];

void OnInit()
{
   //Calculate number of total rows
   num_total_rows = int(MathPow(num_input_types,num_comparers));
   
   //Calculate number of unique rows
   if((num_input_types - num_comparers) < 0){
      num_unique_rows = 0;
   }
   if(num_input_types - num_comparers >= 0){
      num_unique_rows = diff_factorial(num_input_types,num_input_types-num_comparers);
   }
   
   //Calculate number of redundant rows
   num_redundant_rows = num_total_rows - num_unique_rows;
   
   //Calculate number of comparisons
   for(int i = 1; i<=num_comparers; i++){
      num_comparisons += i-1;
   }   
   
   //ReSize arrays
   ArrayResize(unique_table,num_unique_rows);
   
   //Alert Statements
   Alert("***********************Start********************************");
   Alert("num_input_types = "+string(num_input_types));
   Alert("num_comparers = "+string(num_comparers));
   Alert("num_comparisons = "+string(num_comparisons));
   Alert("num_total_rows: "+string(num_total_rows));   
   Alert("num_unique_rows = "+string(num_unique_rows));
   Alert("num_redundant_rows = "+string(num_redundant_rows));
   
   
   
   //For loop creates the unique table
   int counter = 0;
   bool unique_cond = true;
   for(int row = 0; row < num_total_rows; ++row){
      string val = base_converter(row, num_input_types, num_comparers);   
      
      for(int col = 0; col < num_comparers - 1; col++){
         for(int col2 = 1; col2 < num_comparers - col; col2++){
            if(StringGetChar(val,col)==StringGetChar(val,col+col2)){
               
               unique_cond = false;
               
               col2=num_comparers;
               col=num_comparers;     
            } 
         }
      }
      
      if(unique_cond){
         unique_table[counter] = val;
         counter++;
      }
      unique_cond = true;
   }
   
   
   //Print unique table
   //for(int row = 0; row < ArraySize(unique_table); row++){
     // Alert("unique_table row = "+string(row)+" value = "+string(unique_table[row]));
   //}
   
   Alert("unique_table row = "+string(ArraySize(unique_table) - 1)+" value = "+string(unique_table[ArraySize(unique_table) - 1]));
   Alert("iterater = "+string(iterater)+" value = "+unique_table[iterater]);
}


//Base converter helps to make up the lookup table by turning iterater into rows of input types
string base_converter(int number, int base, int str_len){
   
   int int_remainder;
   string str_remainder;
   string val;
   
   while(number!=0){
      int_remainder = number%base;
      number = number/base;
      
      if(int_remainder < 10){str_remainder = IntegerToString(int_remainder);}
      else if(int_remainder == 10){str_remainder = "A";}
      else if(int_remainder == 11){str_remainder = "B";}
      else if(int_remainder == 12){str_remainder = "C";}
      else if(int_remainder == 13){str_remainder = "D";}
      else if(int_remainder == 14){str_remainder = "E";}
      else if(int_remainder == 15){str_remainder = "F";}
      else if(int_remainder == 16){str_remainder = "G";}
      else if(int_remainder == 17){str_remainder = "H";}
      else if(int_remainder == 18){str_remainder = "I";}
      else if(int_remainder == 19){str_remainder = "J";}
      else if(int_remainder == 20){str_remainder = "K";}
      else if(int_remainder == 21){str_remainder = "L";}
      else if(int_remainder == 22){str_remainder = "M";}
      else if(int_remainder == 23){str_remainder = "N";}
      else if(int_remainder == 24){str_remainder = "O";}
      else if(int_remainder == 25){str_remainder = "P";}
      else if(int_remainder == 26){str_remainder = "Q";}
      else if(int_remainder == 27){str_remainder = "R";}
      else if(int_remainder == 28){str_remainder = "S";}
      else if(int_remainder == 29){str_remainder = "T";}
      else if(int_remainder == 30){str_remainder = "U";}
      else if(int_remainder == 31){str_remainder = "V";}
      else if(int_remainder == 32){str_remainder = "W";}
      else if(int_remainder == 33){str_remainder = "X";}
      else if(int_remainder == 34){str_remainder = "Y";}
      else if(int_remainder == 35){str_remainder = "Z";}
      else if(int_remainder == 36){str_remainder = "a";}
      else if(int_remainder == 37){str_remainder = "b";}
      else if(int_remainder == 38){str_remainder = "c";}
      else if(int_remainder == 39){str_remainder = "d";}
      
      val = str_remainder+val;
   }
   
   for(int i = StringLen(val); i < str_len; ++i){
      val = "0"+val;
      //val = IntegerToString(StringToInteger(val),str_len,'0');
   }
   
   return(val);
   //return(StringToInteger(val));
}

int diff_factorial(int high_number, int low_number){
   int number = 1;
   if(high_number-low_number==0)return(1);
   else{
      for(int i = high_number; i > low_number; i--){
         number = number * i;
      }
   }
   return(number);
}


int ticket;
extern double Lots = 1;
int Magic = 200;
bool EnterCond = false;
bool ExitCond = false;


int BBPeriod = 20;
double BBStdDev = 2;
int ADXPeriod = 20;
int MomPeriod = 20;
int RSIPeriod = 20;




void OnTick(){
   
   bool New_Bar = Find_New_Bar();
      
   if(New_Bar){
      
      double Price = Open[0];//0
      double MA_200 = iMA(Symbol(), Period(), 200, 0, MODE_SMA, PRICE_OPEN, 0);
      double MA_150 = iMA(Symbol(), Period(), 150, 0, MODE_SMA, PRICE_OPEN, 0);
      double MA_100 = iMA(Symbol(), Period(), 100, 0, MODE_SMA, PRICE_OPEN, 0);
      double MA_50 = iMA(Symbol(), Period(), 50, 0, MODE_SMA, PRICE_OPEN, 0);
      double MA_25 = iMA(Symbol(), Period(), 25, 0, MODE_SMA, PRICE_OPEN, 0);
      double MA_5 = iMA(Symbol(), Period(), 5, 0, MODE_SMA, PRICE_OPEN, 0);
      double bb_main = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, PRICE_OPEN, MODE_MAIN, 0);
      double bb_upper = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, PRICE_OPEN, MODE_UPPER, 0);
      double bb_lower = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, PRICE_OPEN, MODE_LOWER, 0);
      //double ADX_Main = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MAIN, 0);
      //double ADX_PlusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_PLUSDI, 0);
      //double ADX_MinusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MINUSDI, 0);  
      //double Momentum = iMomentum(Symbol(),Period(),MomPeriod,0,0);
      //double RSI = iRSI(Symbol(),Period(),RSIPeriod,0,0);
      
      
      
      string order = unique_table[iterater];
      
      int order_array[];
      
      ArrayResize(order_array,num_comparers);
      
      for(int i = 0; i < StringLen(order); i++){
         order_array[i] = int(StringToInteger(string(CharToString(uchar(StringGetCharacter(order,i))))));
      }
      
      //for(int i = 0; i < ArraySize(order_array); ++i){
        // Alert("order_array row = "+string(order_array[i]));
      //}
      
      double variables[12];
      
      variables[0] = Price;
      variables[1] = MA_200;
      variables[2] = MA_150;
      variables[3] = MA_100;
      variables[4] = MA_50;
      variables[5] = MA_25;
      variables[6] = MA_5;
      variables[7] = bb_main;
      variables[8] = bb_upper;
      variables[9] = bb_lower;
      /*
      //variables[7] = ADX_Main;
      //variables[8] = ADX_PlusDI;
      //variables[9] = ADX_MinusDI;
      //variables[10] = Momentum;
      //variables[11] = RSI;
      */
      EnterCond = true;
      ExitCond = false;
      
      for(int i = 0; i < num_comparers - 1; i++){
         if(variables[order_array[i]]<=variables[order_array[i+1]]){
            EnterCond = false;
            ExitCond = true;
         }
      }
      
      
      if(EnterCond&&!CheckOpenOrders()){
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
      }
      
      
      if(ExitCond&&CheckOpenOrders()){
         bool rgq = OrderClose(ticket,Lots,Bid,10,0);
      }  
   }
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