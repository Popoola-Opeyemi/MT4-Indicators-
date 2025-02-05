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

//  defining timeframe to use to calculate
enum tf {
  TF_M5=PERIOD_M15, // 15 Minutes
  TF_M30=PERIOD_M30, // 30 Minutes
  TF_H1=PERIOD_H1, // 1 Hour
  TF_H4=PERIOD_H4, // 4 Hours
  TF_D1=PERIOD_D1, // 1 Day
  TF_W1=PERIOD_W1, // 1 Week
  TF_M1=PERIOD_MN1, // 1 Month
};


struct PivotProperty {
   string   symbol;    
   double   pivotpoint;    
   double   r1;    
   double   r2;    
   double   s1;         
   double   s2;
   int      tf;         
  };

struct PeriodProperty {
  string name;
  int period;

};

extern int lineWidth = 2;
extern color pivotcolor = clrGreen, r1color =clrRed,  s1color=clrBlue, labelcolor=clrWhite;  
extern tf timeFrame = TF_W1;   // TimeFrame to calculate  
// extern tf timeFF = TF_M30;

extern bool showSecondSR = true; // display second Resistance and Support
// extern bool showThirdSR = false; // display second Resistance and Support

input bool hideLines = false; // hide all plot 

input string PivotAreas ="===== Pivot Area =====";

input bool PIVOT_1HR = false; // Display hourly Pivot 
input bool PIVOT_4HR = false; // Display 4 hour Pivot 
input bool PIVOT_D1 =  true; // Display Daily Pivot 
input bool PIVOT_W1 =  true; // Display Weekly Pivot 

input string ResistanceAreas ="===== Resistance Areas =====";

input bool R1_1HR = false; // Display 1 HR resistance 
input bool R1_4HR = true; // Display 4HR resistance 
input bool R1_D1 =  true; // Display D1 resistance 
input bool R1_W1 =  true; // Display W1 HR resistance 

input string SupportAreas ="===== Support Areas =====";

input bool S1_1HR = false; // Display hourly support 
input bool S1_4HR = true; // Display 4 hour  support 
input bool S1_D1 =  true; // Display Daily support 
input bool S1_W1 =  false; // Display Weekly support 


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){

  multiTFPivot();
//--- indicator buffers mapping
   
//---
  // generatePoint(timeFrame);
  // Print("generate");
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
  
  ObjectsDeleteAll();
  GlobalVariablesDeleteAll();

  return;

  
}

void multiTFPivot(){
  string Symb = Symbol();


  int periods [] = {PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1};

  // PeriodProperty customPeriods [];

  PivotProperty pivotPoints [4];

  for(int a=0 ;a<ArraySize(periods); a++){
    double Op, Hi ,Lo ,Cl, pp;
    Op = iOpen(NULL,periods[a],1);
    Hi = iHigh(NULL,periods[a],1);
    Lo = iLow(NULL,periods[a],1);
    Cl = iClose(NULL,periods[a],1);
    pp = (Hi + Lo + Cl) / 3;
    
    pivotPoints[a].tf = periods[a];
    pivotPoints[a].pivotpoint = pp;
    pivotPoints[a].r1 = (pp *2 ) - Lo;
    pivotPoints[a].r2 = pp + (Hi - Lo);
    pivotPoints[a].s1 = (pp *2 ) - Hi;
    pivotPoints[a].s2 =  pp - (Hi - Lo);
  }


  if (!hideLines){

    for(int i=0; i<ArraySize(pivotPoints); i++){

      //+------------------------------------------------------------------+
      //| PIVOT POINTS                                                     |
      //+------------------------------------------------------------------+
      if (pivotPoints[i].tf == PERIOD_H1 && PIVOT_1HR == true){
        DrawTrendLine(genObjectName("trendline",pivotPoints[i].pivotpoint), Time[PERIOD_H1], pivotPoints[i].pivotpoint, TimeCurrent(), pivotPoints[i].pivotpoint, clrGreen,STYLE_DASHDOT,2, "");
        CreateLabel(genObjectName("label1",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" pivot" ,Symb,pivotPoints[i].pivotpoint);
      }

      if (pivotPoints[i].tf == PERIOD_H4 && PIVOT_4HR == true){
        DrawTrendLine(genObjectName("trendline",pivotPoints[i].pivotpoint), Time[PERIOD_H1], pivotPoints[i].pivotpoint, TimeCurrent(), pivotPoints[i].pivotpoint, clrGreen,STYLE_DASHDOT,2, "");
        CreateLabel(genObjectName("label1",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" pivot" ,Symb,pivotPoints[i].pivotpoint);
      }

      if (pivotPoints[i].tf == PERIOD_D1 && PIVOT_D1 == true){
        DrawTrendLine(genObjectName("trendline",pivotPoints[i].pivotpoint), Time[PERIOD_H1], pivotPoints[i].pivotpoint, TimeCurrent(), pivotPoints[i].pivotpoint, clrGreen,STYLE_DASHDOT,2, "");
        CreateLabel(genObjectName("label1",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" pivot" ,Symb,pivotPoints[i].pivotpoint);
      }

      if (pivotPoints[i].tf == PERIOD_W1 && PIVOT_W1 == true){
        DrawTrendLine(genObjectName("trendline",pivotPoints[i].pivotpoint), Time[PERIOD_H1], pivotPoints[i].pivotpoint, TimeCurrent(), pivotPoints[i].pivotpoint, clrGreen,STYLE_DASHDOT,2, "");
        CreateLabel(genObjectName("label1",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" pivot" ,Symb,pivotPoints[i].pivotpoint);
      }

      //+------------------------------------------------------------------+
      //| RESISTANCE POINTS                                                |
      //+------------------------------------------------------------------+
      if (pivotPoints[i].tf == PERIOD_H1 && R1_1HR == true){
        DrawTrendLine(genObjectName("resistance",pivotPoints[i].r1), Time[PERIOD_H1], pivotPoints[i].r1, TimeCurrent(), pivotPoints[i].r1, clrRed,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label2",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" r1" ,Symb,pivotPoints[i].r1);

        if (showSecondSR){
          DrawTrendLine(genObjectName("resistance2",pivotPoints[i].r2), Time[PERIOD_H1], pivotPoints[i].r2, TimeCurrent(), pivotPoints[i].r2, clrRed,STYLE_SOLID,2, "");
          CreateLabel(genObjectName("label-R1",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" r2" ,Symb,pivotPoints[i].r2);
        }
      }

      if (pivotPoints[i].tf == PERIOD_H4 && R1_4HR == true){
        DrawTrendLine(genObjectName("resistance",pivotPoints[i].r1), Time[PERIOD_H1], pivotPoints[i].r1, TimeCurrent(), pivotPoints[i].r1, clrRed,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label2",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" r1" ,Symb,pivotPoints[i].r1);

         if (showSecondSR){
          DrawTrendLine(genObjectName("resistance2",pivotPoints[i].r2), Time[PERIOD_H1], pivotPoints[i].r2, TimeCurrent(), pivotPoints[i].r2, clrRed,STYLE_SOLID,2, "");
          CreateLabel(genObjectName("label-R1",pivotPoints[i].r2), getHourString(pivotPoints[i].tf) +" r2" ,Symb,pivotPoints[i].r2);
        }
      }

      if (pivotPoints[i].tf == PERIOD_D1 && R1_D1 == true){
        DrawTrendLine(genObjectName("resistance",pivotPoints[i].r1), Time[PERIOD_H1], pivotPoints[i].r1, TimeCurrent(), pivotPoints[i].r1, clrRed,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label2",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" r1" ,Symb,pivotPoints[i].r1);

         if (showSecondSR){
          DrawTrendLine(genObjectName("resistance2",pivotPoints[i].r2), Time[PERIOD_H1], pivotPoints[i].r2, TimeCurrent(), pivotPoints[i].r2, clrRed,STYLE_SOLID,2, "");
          CreateLabel(genObjectName("label-R1",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" r2" ,Symb,pivotPoints[i].r2);
        }
      }
      
      if (pivotPoints[i].tf == PERIOD_W1 && R1_W1 == true){
        DrawTrendLine(genObjectName("resistance",pivotPoints[i].r1), Time[PERIOD_H1], pivotPoints[i].r1, TimeCurrent(), pivotPoints[i].r1, clrRed,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label2",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" r1" ,Symb,pivotPoints[i].r1);

         if (showSecondSR){
          DrawTrendLine(genObjectName("resistance2",pivotPoints[i].r2), Time[PERIOD_H1], pivotPoints[i].r2, TimeCurrent(), pivotPoints[i].r2, clrRed,STYLE_SOLID,2, "");
          CreateLabel(genObjectName("label-R1",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" r2" ,Symb,pivotPoints[i].r2);
        }
      }

      //+------------------------------------------------------------------+
      //| SUPPORT POINTS                                                   |
      //+------------------------------------------------------------------+
      if (pivotPoints[i].tf == PERIOD_H1 && S1_1HR == true){
        DrawTrendLine(genObjectName("support",pivotPoints[i].s1), Time[PERIOD_H1], pivotPoints[i].s1, TimeCurrent(), pivotPoints[i].s1, clrBlue,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label3",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" s1" ,Symb,pivotPoints[i].s1);
      }

      if (pivotPoints[i].tf == PERIOD_H4 && S1_4HR == true){
        DrawTrendLine(genObjectName("support",pivotPoints[i].s1), Time[PERIOD_H1], pivotPoints[i].s1, TimeCurrent(), pivotPoints[i].s1, clrBlue,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label3",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" s1" ,Symb,pivotPoints[i].s1);
      }

      if (pivotPoints[i].tf == PERIOD_D1 && S1_D1 == true){
        DrawTrendLine(genObjectName("support",pivotPoints[i].s1), Time[PERIOD_H1], pivotPoints[i].s1, TimeCurrent(), pivotPoints[i].s1, clrBlue,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label3",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" s1" ,Symb,pivotPoints[i].s1);
      }
      
      if (pivotPoints[i].tf == PERIOD_W1 && S1_W1 == true){
        DrawTrendLine(genObjectName("support",pivotPoints[i].s1), Time[PERIOD_H1], pivotPoints[i].s1, TimeCurrent(), pivotPoints[i].s1, clrBlue,STYLE_SOLID,2, "");
        CreateLabel(genObjectName("label3",pivotPoints[i].tf), getHourString(pivotPoints[i].tf) +" s1" ,Symb,pivotPoints[i].s1);
      }
      



      if (pivotPoints[i].tf != PERIOD_H1){

      }
    }

  }  
  
    
}


    
    // 
  void CreateLabel(string name, string title, string symbol, double point){
      
      int x, y;
      
      bool result = ChartTimePriceToXY (0, 0, Time [0], point, x, y);
        
      ObjectCreate(name, OBJ_LABEL,0,0,0);
      
      ObjectSetText(name,title,8,"Arial",labelcolor);
      
      ObjectSet(name, OBJPROP_CORNER, 1);
      
      ObjectSet(name, OBJPROP_XDISTANCE, 10);
      
      ObjectSet(name, OBJPROP_YDISTANCE, y - 20);
  }

  void DrawHorizontalLine(string symb, string name, color clr, double point){

    ObjectCreate(name, OBJ_HLINE, 0, 0, point);
    
    ObjectSetInteger(0, name, OBJPROP_COLOR,clr);
    
    ObjectSetInteger(0, name,OBJPROP_WIDTH,lineWidth);

  }
    
string getHourString(int period) {
   string TMz="";
  
   switch(period){
      case PERIOD_M30:   TMz = "M30"; break;
      case PERIOD_H1:    TMz = "H1";  break;
      case PERIOD_H4:    TMz = "H4";  break;
      case PERIOD_D1:    TMz = "D1";  break;
      case PERIOD_W1:    TMz = "W1";  break;
      case PERIOD_MN1:   TMz = "M1";  break;
   }

   return TMz;
}

string genObjectName (string name, double period){
  return name + DoubleToString(period) ;
}


void DrawTrendLine(string sObjName,datetime dtTime1,double dPrice1,datetime dtTime2,double dPrice2,color HL_color,int HL_style,int HL_width, string sObjDesc)
   {
      ObjectCreate(sObjName,OBJ_TREND,0,dtTime1,dPrice1,dtTime2,dPrice2); 
      ObjectSet(sObjName,OBJPROP_COLOR,HL_color);
      ObjectSet(sObjName,OBJPROP_STYLE,HL_style);
      ObjectSet(sObjName,OBJPROP_WIDTH,HL_width);
      ObjectSetText(sObjName,sObjDesc,10,"Times New Roman",Black); 
   }

datetime endTime(){
  // string end = TimeToString(TimeCurrent() + remainHour*60*60, TIME_SECONDS);
  Print(ChartGetInteger(0,CHART_WIDTH_IN_BARS,0));
  
  return StrToTime("23:59");

}