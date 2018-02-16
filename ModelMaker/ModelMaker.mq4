//+------------------------------------------------------------------+
//|                                                    NeuralNet.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//To Do: Add indicator parameters to extern variables to optimize them - could get out of hand quickly!
//Add different data and compair it somehow (even though different indicators have different range of values...
//like ADX and RSI for example, and momentum. You'll have to make them all relative... Normalize them! Duh!!

//Integrate short conditions...?

extern int num_condits = 0;
extern int firstVar = 0;
extern int secondVar = 0;
extern int thirdVar = 0;
extern int fourthVar = 0;
extern int fifthVar = 0;
extern int sixthVar = 0;
extern int seventhVar = 0;
extern int eighthVar = 0;
extern int ninthVar = 0;
extern int tenthVar = 0;
extern int eleventhVar = 0;
extern int twelfthVar = 0;
extern int thirteenthVar = 0;
extern int fourteenthVar = 0;
extern int fifteenthVar = 0;
extern int sixteenthVar = 0;

extern int EnterLogic = 0;
extern int ExitLogic = 0;

//extern int firstCond0_5 = 0;
//extern int secondCond0_4 = 0;

//6+6*5+6*5*4 = 156

extern int StopLoss = 100;
extern int TakeProfit = 100;



//int list[12] = {0,0,0,0,0,0,0,0,0,0,0,0};
int ticket;
extern double Lots = 1;
int Magic = 200;
bool res;
bool EnterCond = false;
bool ExitCond = false;


int BBPeriod = 20;
double BBStdDev = 2;
int ADXPeriod = 20;
int MomPeriod = 20;
int RSIPeriod = 20;





void OnTick(){
      
   bool unique = all_pairs_unique(num_condits,firstVar,secondVar,thirdVar,fourthVar,fifthVar,sixthVar,seventhVar,eighthVar,ninthVar,tenthVar,eleventhVar,twelfthVar,thirteenthVar,fourteenthVar,fifteenthVar,sixteenthVar);
   
   if(!unique){printf("Not Unique!!");}
   
   if(unique){
      
      bool a,b,c,d,e,f,g,h = false;
      
      printf("These ones are unique!");
      
      bool New_Bar = Fun_New_Bar();
      
      if(New_Bar){
         
         //int2bin(integer);
         
         double Price = Open[0];
         double MA_100 = iMA(Symbol(), Period(), 100, 0, MODE_SMA, PRICE_OPEN, 0);
         double MA_25 = iMA(Symbol(), Period(), 25, 0, MODE_SMA, PRICE_OPEN, 0);
         double MA_5 = iMA(Symbol(), Period(), 5, 0, MODE_SMA, PRICE_OPEN, 0);   
         double bb_main = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, PRICE_OPEN, MODE_MAIN, 0);
         double bb_upper = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, PRICE_OPEN, MODE_UPPER, 0);
         double bb_lower = iBands(Symbol(), 0, BBPeriod, BBStdDev, 0, PRICE_OPEN, MODE_LOWER, 0);
         /*
         double ADX_Main = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MAIN, 0);
         double ADX_PlusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_PLUSDI, 0);
         double ADX_MinusDI = iADX(Symbol(), 0, ADXPeriod, PRICE_OPEN, MODE_MINUSDI, 0);  
         double Momentum = iMomentum(Symbol(),Period(),MomPeriod,0,0);
         double RSI = iRSI(Symbol(),Period(),RSIPeriod,0,0);
         //Time of day...
         */
         
         double variables[7];
         variables[0] = Price;
         variables[1] = MA_100;
         variables[2] = MA_25;
         variables[3] = MA_5;
         variables[4] = bb_main;
         variables[5] = bb_upper;
         variables[6] = bb_lower;
         
         double inputs[16];
         inputs[0] = variables[firstVar];
         inputs[1] = variables[secondVar];
         inputs[2] = variables[thirdVar];
         inputs[3] = variables[fourthVar];
         inputs[4] = variables[fifthVar];
         inputs[5] = variables[sixthVar];
         inputs[6] = variables[seventhVar];
         inputs[7] = variables[eighthVar];
         inputs[8] = variables[ninthVar];
         inputs[9] = variables[tenthVar];
         inputs[10] = variables[eleventhVar];
         inputs[11] = variables[twelfthVar];
         inputs[12] = variables[thirteenthVar];
         inputs[13] = variables[fourteenthVar];
         inputs[14] = variables[fifteenthVar];
         inputs[15] = variables[sixteenthVar];
         
         
         if(inputs[0]>inputs[1]){a=true;}
         else{a=false;}
         if(num_condits>=2){
         if(inputs[2]>inputs[3]){b=true;}
         else{b=false;}
         if(num_condits>=3){
         if(inputs[4]>inputs[5]){c=true;}
         else{c=false;}
         if(num_condits>=4){
         if(inputs[6]>inputs[7]){d=true;}
         else{d=false;}
         if(num_condits>=5){
         if(inputs[8]>inputs[9]){e=true;}
         else{e=false;}
         if(num_condits>=6){
         if(inputs[10]>inputs[11]){f=true;}
         else{f=false;}
         if(num_condits>=7){
         if(inputs[12]>inputs[13]){g=true;}
         else{g=false;}
         if(num_condits>=8){
         if(inputs[14]>inputs[15]){h=true;}
         else{h=false;}
         }}}}}}}
         
         if((num_condits==1&&a)||
         (num_condits==2&&a&&b)||
         (num_condits==3&&a&&b&&c)||
         (num_condits==4&&a&&b&&c&&d)||
         (num_condits==5&&a&&b&&c&&d&&e)||
         (num_condits==6&&a&&b&&c&&d&&e&&f)||
         (num_condits==7&&a&&b&&c&&d&&e&&f&&g)||
         (num_condits==8&&a&&b&&c&&d&&e&&f&&g&&h)){
            EnterCond = true;
            ExitCond = false;
         }
         else{
            EnterCond = false; 
            ExitCond = true;
         }
         
         
         
         
         
         
         //Bid-StopLoss*Point,Bid+TakeProfit*Point
         //NULL,NULL
         if(EnterCond&&!CheckOpenOrders()){
            ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,10,NULL,NULL,"Bought Here",Magic,0,0);
         }
         

         if(ExitCond&&CheckOpenOrders()){
            bool rgq = OrderClose(ticket,Lots,Bid,10,0);
         }
      }
   }//OnTick ends
}





//Utility Functions

/*
void int2bin(int param)
{
   int index = 0;
   for(index = 11; index >= 0; index--){
     if((param & (1 << index)) != 0){
       printf("1");
       list[index] = 1;
     }else{
       printf("0");
       list[index] = 0;
     } 
   }
}
*/




bool CheckOpenOrders(){
   for( int i = 0 ; i < OrdersTotal() ; i++ ) {
      bool a = OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
      if( OrderSymbol() == Symbol() && OrderMagicNumber() == Magic ) 
         return(true);
   }
   return(false);
}





// Identify new bars
bool Fun_New_Bar(){
   static datetime New_Time = 0;
   bool New_Bar_local = false;
   if (New_Time!= Time[0]){
      New_Time = Time[0];
      New_Bar_local = true;
      }
   return(New_Bar_local);
}






bool all_pairs_unique(int num_conditions, int i, int j, int k, int l, int m, int n, int o, int p, int q, int r, int s, int t, int u, int v, int w, int x){
   if(num_conditions>=2){
      if(i<=k&&j<=l)return false;
   }
   if(num_conditions>=3){
      if(i<=m&&j<=n)return false;
      if(k<=m&&l<=n)return false;
   }
   if(num_conditions>=4){
      if(i<=o&&j<=p)return false;
      if(k<=o&&l<=p)return false;
      if(m<=o&&n<=p)return false;
   }
   if(num_conditions>=5){
      if(i<=q&&j<=r)return false;
      if(k<=q&&l<=r)return false;
      if(m<=q&&n<=r)return false;
      if(o<=q&&p<=r)return false;
   }
   if(num_conditions>=6){
      if(i<=s&&j<=t)return false;
      if(k<=s&&l<=t)return false;
      if(m<=s&&n<=t)return false;
      if(o<=s&&p<=t)return false;
      if(q<=s&&r<=t)return false;
   }
   if(num_conditions>=7){
      if(i<=u&&j<=v)return false;
      if(k<=u&&l<=v)return false;
      if(m<=u&&n<=v)return false;
      if(o<=u&&p<=v)return false;
      if(q<=u&&r<=v)return false;
      if(s<=u&&t<=v)return false;
   }
   if(num_conditions>=8){
      if(i<=w&&j<=x)return false;
      if(k<=w&&l<=x)return false;
      if(m<=w&&n<=x)return false;
      if(o<=w&&p<=x)return false;
      if(q<=w&&r<=x)return false;
      if(s<=w&&t<=x)return false;
      if(u<=w&&v<=x)return false;
   }
   return true;
}



//bool redundant_set(int num_conditions, int i, int j, int k, int l, int m, int n, int o, int p, int q, int r, int s, int t, int u, int v, int w, int x){
//   return false;   
//}




//Appendix

        //Enter Conditions:
        //if(EnterLogic==0&&(a&&b&&c)){EnterCond = true;}
        //else if(EnterLogic==1&&a){EnterCond = true;}
        //else if(EnterLogic==2&&(a||b||c)){EnterCond = true;}
        //else if(EnterLogic==2&&(a!=b)){EnterCond = true;}
        //else{EnterCond=false;}
        
        //Exit Conditions:
        //if(ExitLogic==0&&!(a&&b&&c)){ExitCond = true;}
        //else if(ExitLogic==1&&!a){ExitCond = true;}
        //else if(ExitLogic==2&&!b){ExitCond = true;}
        //else if(ExitLogic==3&&!c){ExitCond = true;}
        //else if(ExitLogic==4&&!(a||b||c)){ExitCond = true;}
        //else if(ExitLogic==2&&!(a!=b)){ExitCond = true;}
        //else {ExitCond = false;}