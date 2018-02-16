//+------------------------------------------------------------------+
//|                                                     WatchDog.mq4 |
//|                                                Copyright, Kirill |
//|                                         http://www.ForexBoat.com |
//+------------------------------------------------------------------+
#property copyright "Copyright, Kirill"
#property link      "http://www.ForexBoat.com"
#property version   "1.00"
#property strict

extern int AccountRow = 1;  
extern int DelayMinutes = 2;    
 
// AccountRow   - Your favourites account number
// DelayMinutes - Delay in minutes, has to be greater than the chart timeframe

#include <WinUser32.mqh>
#import "user32.dll"
  int GetParent(int hWnd);
  int GetDlgItem(int hDlg, int nIDDlgItem);
  int GetLastActivePopup(int hWnd);
#import
 
#define VK_HOME 0x24
#define VK_DOWN 0x28
#define VK_ENTER 0x0D
 
#define PAUSE 1000
datetime Old_Time=0;
bool is_reconect = true;
 
void OnInit()
{
   Old_Time=iTime(NULL,0,0);
   OnTick();
}
 
void OnTick()
{
   if (!IsDllsAllowed())
   {
      Alert("Watchdog: DLLs not alllowed!");
      return;
   }
   
   while (!IsStopped())
   {
      RefreshRates();
      if (Old_Time  == iTime(NULL,0,0)) is_reconect=true;
      else is_reconect=false;
      Old_Time=iTime(NULL,0,0);
      if (is_reconect)
      {
         Print("Watchdog: The chart has not been updated in " + string(DelayMinutes) + " minutes. Initating reconnection procedure...");
         Login(AccountRow);
      }
      Sleep(DelayMinutes*60*1000);
   }
   return;
}

void Login(int Num)
{
   int hwnd = WindowHandle(Symbol(), Period());
   int hwnd_parent = 0;
   
   while (!IsStopped())
   {
      hwnd = GetParent(hwnd);
      if (hwnd == 0) break;
      hwnd_parent = hwnd;
   }
   
   if (hwnd_parent != 0)  
   {
      hwnd = GetDlgItem(hwnd_parent, 0xE81C); 
      hwnd = GetDlgItem(hwnd, 0x52);
      hwnd = GetDlgItem(hwnd, 0x8A70);
      
      PostMessageA(hwnd, WM_KEYDOWN, VK_HOME,0); 
      
      while (Num > 1)  
      {
         PostMessageA(hwnd, WM_KEYDOWN,VK_DOWN, 0); 
         Num--;
      }
      
      PostMessageA(hwnd, WM_KEYDOWN, VK_ENTER, 0);  
      Sleep(PAUSE);                                 
      
      hwnd = GetLastActivePopup(hwnd_parent);  
      PostMessageA(hwnd, WM_KEYDOWN, VK_ENTER, 0); 
   }
 
   return;
}