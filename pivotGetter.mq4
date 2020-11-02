//+------------------------------------------------------------------+
//|                                                  pivotGetter.mq4 |
//|                                                  Opeyemi Popoola |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Opeyemi Popoola"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


extern int lineWidth = 2;
extern color pivotcolor = clrGreen, r1color =clrRed,  s1color=clrBlue;    
extern int timeFrame = 10080;   // 43200, 10080, 1440, 240, 60, 30, 5, 1

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
  generatePoint(timeFrame);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void OnDeinit(const int reason){
   ObjectDelete(0,"pivot point");
   ObjectDelete(0,"r1");
   ObjectDelete(0,"s1");
   ObjectDelete(0,"label1");
   ObjectDelete(0,"label2");
   ObjectDelete(0,"label3");

  
}

void generatePoint(int period){
    double Op, Hi ,Lo ,Cl;

    Op = iOpen(NULL,period,1);
    Hi = iHigh(NULL,period,1);
    Lo = iLow(NULL,period,1);
    Cl = iClose(NULL,period,1);
    
    string Symb = Symbol();

    double pp = (Hi + Lo + Cl) / 3;
        
    double r1 = (pp *2 ) - Lo;
    double r2 = pp + (Hi - Lo);
    
    double s1 = (pp *2 ) - Hi;
    double s2 =  pp - (Hi - Lo);
    
    
    //  Pivot Point 
    DrawHorizontalLine(Symb, "pivot point", pivotcolor, pp );
    CreateLabel("label1", "PP",Symb,pp);
   
    
    //--- Resistance 

    DrawHorizontalLine(Symb, "r1", r1color, r1 );
    CreateLabel("label2", "R1",Symb,r1);
    
    //--- SUPPORT 
  
    DrawHorizontalLine(Symb, "s1", s1color, s1 );
    CreateLabel("label3", "S1",Symb,s1);

    Comment("Weekly Pivot "+DoubleToStr(pp,Digits)+ " High "+DoubleToStr(Hi,Digits)+ " Low "+DoubleToStr(Lo,Digits)+" Close "+DoubleToStr(Cl,Digits));
    
    }
    
    // 
  void CreateLabel(string name, string title, string symbol, double point){
      
      int x, y;
      
      bool result = ChartTimePriceToXY (0, 0, Time [0], point, x, y);
        
      ObjectCreate(name, OBJ_LABEL,0,0,0);
      
      ObjectSetText(name,title,8,"Arial",Red);
      
      ObjectSet(name, OBJPROP_CORNER, 1);
      
      ObjectSet(name, OBJPROP_XDISTANCE, 20);
      
      ObjectSet(name, OBJPROP_YDISTANCE, y);
  }

  void DrawHorizontalLine(string symb, string name, color clr, double point){

    ObjectCreate(symb, name, OBJ_HLINE, 0, 0, point);
    
    ObjectSetInteger(0, name, OBJPROP_COLOR,clr);
    
    ObjectSetInteger(0, name,OBJPROP_WIDTH,lineWidth);

  }
    