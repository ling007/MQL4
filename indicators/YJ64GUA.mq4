//+------------------------------------------------------------------+
//|                                                      YJ64GUA.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 White

#include <MovingAverages.mqh>
int fontsize=12;
int dnCount=0;
int shu=0;
int atrPeriod=60;

color guaColor[5];

double buf1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

   SetIndexStyle(0,DRAW_LINE);

   SetIndexBuffer(0,buf1);
   SetIndexEmptyValue(0,0.0);
   ObjectsDeleteAll();

   guaColor[0] = DodgerBlue;;
   guaColor[1] = DeepPink;
   guaColor[2] = Aqua;
   guaColor[3] = Coral;
   guaColor[4] = MediumPurple;

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {

   ObjectsDeleteAll();

   return(0);
  }
//+------------------------------------------------------------------+
//| Draw a rectangle map images                                      |
//+------------------------------------------------------------------+
void DrawRect()
  {
   int yao1,yao2,yao3,yao4,yao5,yao6;
   double x,y;
   double xi,yi;
   color clr;
   x=250;
   y=9;
   xi=25;
   yi=3;
   clr=clrBlue;
   for(int j=0; j<=63;j++)
     {
      yao6=(int)MathFloor(j/32);
      yao5=(int)MathFloor(MathMod(j,32)/16);
      yao4=(int)MathFloor(MathMod(j,16)/8);
      yao3=(int)MathFloor(MathMod(j,8)/4);
      yao2=(int)MathFloor(MathMod(j,4)/2);
      yao1=(int)MathMod(j,2);

      if(j==32) {x=250;y=680;clr=clrBlue;}
      if(yao6==1) PositiveDrawRect("yao6-"+IntegerToString(j),x,y+15,clr);
      else NegativeDrawRect("yao6-"+IntegerToString(j),x,y+15,clr);
      if(yao5==1) PositiveDrawRect("yao5-"+IntegerToString(j),x,y+12,clr);
      else NegativeDrawRect("yao5-"+IntegerToString(j),x,y+12,clr);
      if(yao4==1) PositiveDrawRect("yao4-"+IntegerToString(j),x,y+9,clr);
      else NegativeDrawRect("yao4-"+IntegerToString(j),x,y+9,clr);
      if(yao3==1) PositiveDrawRect("yao3-"+IntegerToString(j),x,y+6,clr);
      else NegativeDrawRect("yao3-"+IntegerToString(j),x,y+6,clr);
      if(yao2==1) PositiveDrawRect("yao2-"+IntegerToString(j),x,y+3,clr);
      else NegativeDrawRect("yao2-"+IntegerToString(j),x,y+3,clr);
      if(yao1==1) PositiveDrawRect("yao1-"+IntegerToString(j),x,y,clr);
      else NegativeDrawRect("yao1-"+IntegerToString(j),x,y,clr);
      x=x+xi;

     }

  }
//+------------------------------------------------------------------+
//| Draw positive rectangle map images                               |
//+------------------------------------------------------------------+
void PositiveDrawRect(string name,double x,double y,color clr)
  {
   ObjectCreate(name+"-1",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet(name+"-1",OBJPROP_XDISTANCE,x);
   ObjectSet(name+"-1",OBJPROP_YDISTANCE,y);
   ObjectSetText(name+"-1","-",12,"Arial Narrow",clr);
   ObjectCreate(name+"-2",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet(name+"-2",OBJPROP_XDISTANCE,x+5);
   ObjectSet(name+"-2",OBJPROP_YDISTANCE,y);
   ObjectSetText(name+"-2","-",12,"Arial Narrow",clr);
   ObjectCreate(name+"-3",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet(name+"-3",OBJPROP_XDISTANCE,x+10);
   ObjectSet(name+"-3",OBJPROP_YDISTANCE,y);
   ObjectSetText(name+"-3","-",12,"Arial Narrow",clr);
  }
//+------------------------------------------------------------------+
//| Draw negative rectangle map images                               |
//+------------------------------------------------------------------+
void NegativeDrawRect(string name,double x,double y,color clr)
  {
   ObjectCreate(name+"-1",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet(name+"-1",OBJPROP_XDISTANCE,x);
   ObjectSet(name+"-1",OBJPROP_YDISTANCE,y);
   ObjectSetText(name+"-1","-",12,"Arial Narrow",clr);
   ObjectCreate(name+"-2",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet(name+"-2",OBJPROP_XDISTANCE,x+5);
   ObjectSet(name+"-2",OBJPROP_YDISTANCE,y);
   ObjectSetText(name+"-2"," ",12,"Arial Narrow",clr);
   ObjectCreate(name+"-3",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet(name+"-3",OBJPROP_XDISTANCE,x+10);
   ObjectSet(name+"-3",OBJPROP_YDISTANCE,y);
   ObjectSetText(name+"-3","-",12,"Arial Narrow",clr);
  }
//+------------------------------------------------------------------+
//| Mark candle name of gua                                          |
//+------------------------------------------------------------------+
int Gua(int shift)
  {
   int yao1,yao2,yao3,yao4,yao5,yao6;
   int guashu;
   int colori;
   string txt1,txt2,txt3;
   string label,label1,label2;
   double y1,y2;
   double ATR;

   string yao1Name,yao2Name,yao3Name,yao4Name,yao5Name,yao6Name;

   datetime time=iTime(Symbol(),0,shift);
   int shift0=iBarShift(Symbol(),5,time,true);
   int shift1=iBarShift(Symbol(),15,time,true);
   int shift2=iBarShift(Symbol(),60,time,true);
   int shift3=iBarShift(Symbol(),240,time,true);
   int shift4=iBarShift(Symbol(),1440,time,true);
   int shift5=iBarShift(Symbol(),7200,time,true);

   if(shift5<0 || shift4<0 || shift3<0 || shift2<0 || shift1<0 || shift0<0 ) return(-1);
   if(iClose(NULL,PERIOD_M5,(int)MathFloor(shift0))>iOpen(NULL,PERIOD_M5,(int)MathFloor(shift0))) yao1=1; else yao1=0;
   if(iClose(NULL,PERIOD_M15,(int)MathFloor(shift1))>iOpen(NULL,PERIOD_M15,(int)MathFloor(shift1))) yao2=1; else yao2=0;
   if(iClose(NULL,PERIOD_H1, (int)MathFloor(shift2))>iOpen(NULL,PERIOD_H1,(int)MathFloor(shift2))) yao3=1; else yao3=0;
   if(iClose(NULL,PERIOD_H4, (int)MathFloor(shift3))>iOpen(NULL,PERIOD_H4,(int)MathFloor(shift3))) yao4=1; else yao4=0;
   if(iClose(NULL,PERIOD_D1, (int)MathFloor(shift4))>iOpen(NULL,PERIOD_D1,(int)MathFloor(shift4))) yao5=1; else yao5=0;
   if(iClose(NULL,PERIOD_W1, (int)MathFloor(shift5))>iOpen(NULL,PERIOD_W1,(int)MathFloor(shift5))) yao6=1; else yao6=0;

   guashu=yao6*32+yao5*16+yao4*8+yao3*4+yao2*2+yao1*1;
   if(guashu!=shu)
     {
      switch(guashu)
        {
         case 0: txt1="坤";txt2=" ";break;
         case 1: txt1="剥";txt2=" ";break;
         case 2: txt1="比";txt2=" ";break;
         case 3: txt1="观";txt2=" ";break;
         case 4: txt1="豫";txt2=" ";break;
         case 5: txt1="晋";txt2=" ";break;
         case 6: txt1="萃";txt2=" ";break;
         case 7: txt1="否";txt2=" ";break;
         case 8: txt1="谦";txt2=" ";break;
         case 9: txt1="艮";txt2=" ";break;
         case 10: txt1="蹇";txt2=" ";break;
         case 11: txt1="渐";txt2=" ";break;
         case 12: txt1="小";txt2="过";break;
         case 13: txt1="旅";txt2=" ";break;
         case 14: txt1="咸";txt2=" ";break;
         case 15: txt1="遁";txt2=" ";break;
         case 16: txt1="师";txt2=" ";break;
         case 17: txt1="蒙";txt2=" ";break;
         case 18: txt1="坎";txt2=" ";break;
         case 19: txt1="涣";txt2=" ";break;
         case 20: txt1="解";txt2=" ";break;
         case 21: txt1="未";txt2="济";break;
         case 22: txt1="困";txt2=" ";break;
         case 23: txt1="讼";txt2=" ";break;
         case 24: txt1="升";txt2=" ";break;
         case 25: txt1="蛊";txt2=" ";break;
         case 26: txt1="井";txt2=" ";break;
         case 27: txt1="巽";txt2=" ";break;
         case 28: txt1="恒";txt2=" ";break;
         case 29: txt1="鼎";txt2=" ";break;
         case 30: txt1="大";txt2="过";break;
         case 31: txt1="姤";txt2=" ";break;
         case 32: txt1="复";txt2=" ";break;
         case 33: txt1="颐";txt2=" ";break;
         case 34: txt1="屯";txt2=" ";break;
         case 35: txt1="益";txt2=" ";break;
         case 36: txt1="震";txt2=" ";break;
         case 37: txt1="噬";txt2="嗑";break;
         case 38: txt1="随";txt2=" ";break;
         case 39: txt1="无";txt2="妄";break;
         case 40: txt1="明";txt2="夷";break;
         case 41: txt1="贲";txt2=" ";break;
         case 42: txt1="既";txt2="济";break;
         case 43: txt1="家";txt2="人";break;
         case 44: txt1="丰";txt2=" ";break;
         case 45: txt1="离";txt2=" ";break;
         case 46: txt1="革";txt2=" ";break;
         case 47: txt1="同";txt2="人";break;
         case 48: txt1="临";txt2=" ";break;
         case 49: txt1="损";txt2=" ";break;
         case 50: txt1="节";txt2=" ";break;
         case 51: txt1="中";txt2="孚";break;
         case 52: txt1="归";txt2="妹";break;
         case 53: txt1="睽";txt2=" ";break;
         case 54: txt1="兑";txt2=" ";break;
         case 55: txt1="履";txt2=" ";break;
         case 56: txt1="泰";txt2=" ";break;
         case 57: txt1="大";txt2="畜";break;
         case 58: txt1="需";txt2=" ";break;
         case 59: txt1="小";txt2="畜";break;
         case 60: txt1="大";txt2="壮";break;
         case 61: txt1="大";txt2="有";break;
         case 62: txt1="夬";txt2=" ";break;
         case 63: txt1="乾";txt2=" ";break;
         default: txt1=" ";txt2=" "; break;
        }

      label1 ="gua1"+TimeToStr(Time[shift0],TIME_DATE|TIME_MINUTES);
      label2 ="gua2"+TimeToStr(Time[shift0],TIME_DATE|TIME_MINUTES);
      if(ObjectFind(label1)>=0)
        {
         ObjectSetText(label1,txt1,fontsize,"Arial",guaColor[colori]);
         ObjectSetText(label2,txt2,fontsize,"Arial",guaColor[colori]);
        }
      else
        {
         dnCount++;
         colori=(int)MathMod(dnCount,5);

         ATR=iATR(Symbol(),0,atrPeriod,shift);
         y1=buf1[shift];
         y2=buf1[shift];

         if(Close[shift+1]>buf1[shift])
           {
            y2=Low[shift+1]-ATR/5;
            y1=Low[shift+1];
           }
         else
           {
            y1=High[shift+1]+ATR/5;
            y2=High[shift+1];
           }

         ObjectCreate(label1,OBJ_TEXT,0,Time[shift],y1);
         ObjectSetText(label1,txt1,fontsize,"Arial",guaColor[colori]);
         ObjectCreate(label2,OBJ_TEXT,0,Time[shift],y2);
         ObjectSetText(label2,txt2,fontsize,"Arial",guaColor[colori]);
        }
     }
   shu=guashu;

   return(0);


  }
//+------------------------------------------------------------------+
//| Display and description of the current candle Gua                |
//+------------------------------------------------------------------+
int CurrentGua(int shift)
  {
   int yao1,yao2,yao3,yao4,yao5,yao6;
   int guaNo;
   string txt1,txt2,txt3,txt4;
   color clr;
   string yao1Name,yao2Name,yao3Name,yao4Name,yao5Name,yao6Name;

   datetime time=iTime(Symbol(),0,shift);
   int shift0=iBarShift(Symbol(),5,time,true);
   int shift1=iBarShift(Symbol(),15,time,true);
   int shift2=iBarShift(Symbol(),60,time,true);
   int shift3=iBarShift(Symbol(),240,time,true);
   int shift4=iBarShift(Symbol(),1440,time,true);
   int shift5=iBarShift(Symbol(),7200,time,true);

   if(shift5<0 || shift4<0 || shift3<0 || shift2<0 || shift1<0 || shift0<0 ) return(-1);
   if(iClose(NULL,PERIOD_M5,shift0)>iOpen(NULL,PERIOD_M5,shift0)) yao1=1; else yao1=0;
   if(iClose(NULL,PERIOD_M15,shift1)>iOpen(NULL,PERIOD_M15,shift1)) yao2=1; else yao2=0;
   if(iClose(NULL,PERIOD_H1, shift2)>iOpen(NULL,PERIOD_H1,shift2)) yao3=1; else yao3=0;
   if(iClose(NULL,PERIOD_H4, shift3)>iOpen(NULL,PERIOD_H4,shift3)) yao4=1; else yao4=0;
   if(iClose(NULL,PERIOD_D1, shift4)>iOpen(NULL,PERIOD_D1,shift4)) yao5=1; else yao5=0;
   if(iClose(NULL,PERIOD_W1, shift5)>iOpen(NULL,PERIOD_W1,shift5)) yao6=1; else yao6=0;

   guaNo=yao6*32+yao5*16+yao4*8+yao3*4+yao2*2+yao1*1;

   switch(guaNo)
     {
      case 0: txt1="坤";txt2=" ";
      txt3="元亨。利牝马之贞。君子有攸往，先迷，后得主，利。西南得朋，东北丧朋。安贞吉。";
      txt4="饿虎得食喜气欢，求名应事主高迁。出门吉利行人到，是非口舌不相干。";
      break;
      case 1: txt1="剥";txt2=" ";
      txt3="不利有攸往。";
      txt4="花遇甘露旱逢河，生意买卖利息多。婚姻自有人来助，出门永不受折磨。";
      break;
      case 2: txt1="比";txt2=" ";
      txt3="吉。原筮，元，永贞，无咎。不宁方来，后夫凶。";
      txt4="顺风行船撒起棚，上天又助一篷风。不用费力逍遥去，任意而行大亨通。";
      break;
      case 3: txt1="观";txt2=" ";
      txt3="盥而不荐。有孚顒若。";
      txt4="鹊遇天晚宿林中，不知林内先有鹳。虽然同处心生恶，卦外逢之事非轻。";
      break;
      case 4: txt1="豫";txt2=" ";
      txt3="利建侯行师。";
      txt4="青龙得意喜气生，谋望求财事有成。婚姻出行无阻隔，是非口舌的安宁。";
      break;
      case 5: txt1="晋";txt2=" ";
      txt3="康侯用锡马蕃庶，昼日三接。";
      txt4="锄地锄去苗里草，谁想财帛将人找，谋望求财皆如意，这个运气也算好。";
      break;
      case 6: txt1="萃";txt2=" ";
      txt3="亨，王假有庙。利见大人。亨，利贞，用大牲吉。利有攸往。";
      txt4="鲤鱼化龙喜气来，口舌疾病永无灾。愁疑从此都消散，祸门闭来福门开。";
      break;
      case 7: txt1="否";txt2=" ";
      txt3="否之匪人，不利君子贞，大往小来。";
      txt4="虎落陷坑不堪言，前进容易退后难。谋望不遂自己便，疾病口舌有牵连。";
      break;
      case 8: txt1="谦";txt2=" ";
      txt3="亨。君子有终。";
      txt4="天赐贫人一封金，不用争来二人分。彼此分得金到手，一切谋望皆遂心。";
      break;
      case 9: txt1="艮";txt2=" ";
      txt3="艮其背，不获其身，行其庭，不见其人，无咎。";
      txt4="财帛常打心中走，可惜眼前难到手。不如一时且忍耐，遇着闲事休开口。";
      break;
      case 10: txt1="蹇";txt2=" ";
      txt3="利西南，不利东北。利见大人。贞吉。";
      txt4="大雨倾地雪满天，路上行人苦又难，拖泥带水费尽力，事不遂心且耐烦。";
      break;
      case 11: txt1="渐";txt2=" ";
      txt3="女归吉，利贞。";
      txt4="凤凰落在西岐山，长鸣几声出圣贤。天降文王开基业，富贵荣华八百年。";
      break;
      case 12: txt1="小";txt2="过";
      txt3="亨。利贞。可小事，不可大事。飞鸟遗之音，不宜上，宜下，大吉。";
      txt4="行人路过独木桥，心内惶恐眼里跳。爽利保保过得去，慢行一步不安牢。";
      break;
      case 13: txt1="旅";txt2=" ";
      txt3="小亨。旅贞吉。";
      txt4="飞鸟树上筑高巢，小人使计用火烧。如占此卦大不利，一切谋望枉徒劳。";
      break;
      case 14: txt1="咸";txt2=" ";
      txt3="亨。利贞。取女吉。";
      txt4="脚踏棒槌转悠悠，时运不来莫强求。幸喜今日时运转，自有好事在后头。";
      break;
      case 15: txt1="遁";txt2=" ";
      txt3="亨。小利贞。";
      txt4="浓云遮日不光明，劝君切莫远出行。婚姻求财皆不吉，须防口舌到门庭。";
      break;
      case 16: txt1="师";txt2=" ";
      txt3="贞丈人吉，无咎。";
      txt4="将帅领旨去出征，骑着烈马拉硬弓。百步穿杨去的准，箭射金钱喜气生。";
      break;
      case 17: txt1="蒙";txt2=" ";
      txt3="亨。匪我求童蒙，童蒙求我。初筮告，再三渎，渎则不告。利贞。";
      txt4="卦中气象犯小耗，谋望求财枉徒劳。婚姻合伙有人破，交易出行犯唠叨。";
      break;
      case 18: txt1="坎";txt2=" ";
      txt3="有孚维心，亨。行有尚。";
      txt4="一路明月照水中，只见影儿不见踪。愚人当财下去取，摸来摸去一场空。";
      break;
      case 19: txt1="涣";txt2=" ";
      txt3="亨。王假有庙。利涉大川，利贞。";
      txt4="隔河望见一锭金，欲取河宽水又深。指望钱财难到手，日夜思想妄费心。";
      break;
      case 20: txt1="解";txt2=" ";
      txt3="利西南。无所往，其来复吉。有攸往，夙吉。";
      txt4="五关脱难运抬头，劝君须当把财求。交易出行有人助，疾病口舌不用愁。";
      break;
      case 21: txt1="未";txt2="济";
      txt3="亨。小狐汔济，濡其尾，无攸利。";
      txt4="太岁入运事多愁，婚姻财帛莫强求。交易出门走见吉，走失行人不露头。";
      break;
      case 22: txt1="困";txt2=" ";
      txt3="亨。贞大人吉，无咎。有言不信。";
      txt4="时运不来有人欺，千方百计费商议。明明与你说好话，撮上杆去抽了梯。";
      break;
      case 23: txt1="讼";txt2=" ";
      txt3="有孚窒惕，中吉，终凶。利见大人。不利涉大川。";
      txt4="二人争路未肯降，占着此卦费主张。交易出行有阻隔，生意合伙有平常。";
      break;
      case 24: txt1="升";txt2=" ";
      txt3="元亨。用见大人，勿恤。南征吉。";
      txt4="指日离升气象新，走失行人有音信。功名出行遂心好，疾病口舌皆除根。";
      break;
      case 25: txt1="蛊";txt2=" ";
      txt3="元亨。利涉大川，先甲三日，后甲三日。";
      txt4="卦中象如推磨，顺当为福反为祸。心中有数事改变，凡事尽从忙里错。";
      break;
      case 26: txt1="井";txt2=" ";
      txt3="改邑不改井，无丧无得。往来井井。汔至，亦未繘井，羸其瓶，凶。";
      txt4="枯井破了已多年，一朝涌泉出水新。资生济渴人称羡，时来运转乐自然。";
      break;
      case 27: txt1="巽";txt2=" ";
      txt3="小亨。利有攸往。利见大人。";
      txt4="泛舟得水离沙滩，出外行人早回家。是非口舌皆无碍，婚姻合伙更不差。";
      break;
      case 28: txt1="恒";txt2=" ";
      txt3="亨。无咎。利贞。利有攸往。";
      txt4="鱼来撞网乐自然，卦占行人不久还。交易婚姻两成就，谋望求财不费难。";
      break;
      case 29: txt1="鼎";txt2=" ";
      txt3="元吉，亨。";
      txt4="若占此卦喜自然，求名求利两周全。婚姻合伙皆如意，生意兴隆乐自然。";
      break;
      case 30: txt1="大";txt2="过";
      txt3="栋挠，利有攸往，亨。";
      txt4="夜梦金银醒来空，求名求利大不通。婚姻难成交易散，走失行人不见踪。";
      break;
      case 31: txt1="姤";txt2=" ";
      txt3="女壮，勿用取女。";
      txt4="他乡遇友喜气欢，须知运气福重添。自今交了顺当运，向后保管不相干。";
      break;
      case 32: txt1="复";txt2=" ";
      txt3="亨。出入无疾。朋来无咎。反覆其道，七日来复，利有攸往。";
      txt4="若占此卦不相和，忧疑愁闲无定夺。恩人无义反成怨，是非平地起风波。";
      break;
      case 33: txt1="颐";txt2=" ";
      txt3="贞吉。观颐，自求口实。";
      txt4="文王访贤在渭滨，谋望求财事遂心。交易出行方如意，疾病口舌可离身。";
      break;
      case 34: txt1="屯";txt2=" ";
      txt3="元亨，利贞。勿用有攸往。利建侯。";
      txt4="风刮乱丝不见头，颠三倒四犯忧愁。慢行缓来头有绪，急促反惹不自由。";
      break;
      case 35: txt1="益";txt2=" ";
      txt3="利有攸往。利涉大川。";
      txt4="时来运转喜气发，多年枯木又开花。枝叶重生多茂盛，几人见了几人夸。";
      break;
      case 36: txt1="震";txt2=" ";
      txt3="亨。震来虩虩，笑言哑哑，震惊百里，不丧匕鬯。";
      txt4="占者逢之撞金钟，时来运转响一声。谋事求财不费力，交易合伙大亨通。";
      break;
      case 37: txt1="噬";txt2="嗑";
      txt3="亨。利用狱。";
      txt4="运拙如同身受饥，幸得送饭又遇食。适口充肠心欢喜，忧愁从此渐消移。";
      break;
      case 38: txt1="随";txt2=" ";
      txt3="元亨，利贞，无咎。";
      txt4="推车靠堰道路干，谋望求财不费难。婚姻出行无阻隔，疾病口舌保平安。";
      break;
      case 39: txt1="无";txt2="妄";
      txt3="元亨，利贞。其匪正有眚，不利有攸往。";
      txt4="鸟如笼中难出头，占着此卦不自由。谋望求财不定准，疾病忧犯口舌愁。";
      break;
      case 40: txt1="明";txt2="夷";
      txt3="利艰贞。";
      txt4="时乖运拙走不着，急忙过河拆了桥。恩人无义反为怨，凡事无功枉受劳。";
      break;
      case 41: txt1="贲";txt2=" ";
      txt3="亨。小利有攸往。";
      txt4="时来运转锐气周，窈窕淑女君子求。钟古乐之大吉庆，占着此卦喜临头。";
      break;
      case 42: txt1="既";txt2="济";
      txt3="亨小，利贞。初吉终乱。";
      txt4="金榜之上提姓名，不负当年苦用功。人逢此卦多吉庆，一切谋望大亨通。";
      break;
      case 43: txt1="家";txt2="人";
      txt3="利女贞。";
      txt4="镜里观花休认真，谋望求财不遂心。交易慢成婚姻散，走失行人无音信。";
      break;
      case 44: txt1="丰";txt2=" ";
      txt3="亨，王假之。勿忧，宜日中。";
      txt4="古镜昏暗好几年，一朝磨明似月圆。君子谋事占此卦，时来运转乐自然。";
      break;
      case 45: txt1="离";txt2=" ";
      txt3="利贞。亨。畜牝牛吉。";
      txt4="占此卦者遇天宫，富禄必然降人间。一切谋望皆吉庆，愁闲消散主平安。";
      break;
      case 46: txt1="革";txt2=" ";
      txt3="已日乃孚。元亨。利贞，悔亡。";
      txt4="苗逢旱天渐渐衰，幸得天恩降雨来。忧去喜来能变化，求谋诸事遂心怀。";
      break;
      case 47: txt1="同";txt2="人";
      txt3="同人于野，亨。利涉大川。利君子贞。";
      txt4="仙人指路过路通，劝君任意走西东。交易求财不费力，生意合伙也相通。";
      break;
      case 48: txt1="临";txt2=" ";
      txt3="元亨，利贞。至于八月有凶。";
      txt4="发政施仁志量高，出外求财任逍遥。交易婚姻大有意，走失行人有信耗。";
      break;
      case 49: txt1="损";txt2=" ";
      txt3="有孚，元吉，无咎。可贞，利有攸往。曷之用？二簋可用享。";
      txt4="时运不至费心多，比作推车受折磨。山路崎岖掉了耳，左插右安安不着。";
      break;
      case 50: txt1="节";txt2=" ";
      txt3="亨。苦节，不可贞。";
      txt4="时来运转喜气生，登台封神姜太公。到此诸神皆退位，纵然有祸不成凶。";
      break;
      case 51: txt1="中";txt2="孚";
      txt3="豚鱼，吉。利涉大川，利贞。";
      txt4="此卦占之运气歹，如同太公做买卖。贩猪羊快贩牛迟，猪羊齐贩断了宰。";
      break;
      case 52: txt1="归";txt2="妹";
      txt3="征凶，无攸利。";
      txt4="求鱼须当向水中，树上求之不顺情。受尽爬揭难遂意，劳而无功事不成。";
      break;
      case 53: txt1="睽";txt2=" ";
      txt3="小事吉。";
      txt4="路上行人色匆匆，过河无桥遇薄冰。小心谨慎过得去，一步错了落水中。";
      break;
      case 54: txt1="兑";txt2=" ";
      txt3="亨。利贞。";
      txt4="这个卦象真有趣，觉着做事不费力。休要错过这机会，事事就觉遂心意。";
      break;
      case 55: txt1="履";txt2=" ";
      txt3="履虎尾，不咥人。亨。";
      txt4="俊鸟幸得出笼中，脱离灾难显威风。一朝得志凌云去，东南西北任意行。";
      break;
      case 56: txt1="泰";txt2=" ";
      txt3="小往大来，吉，亨。";
      txt4="喜报三元运气强，谋望求财大吉祥。交易出行多得意，是非口舌总无妨。";
      break;
      case 57: txt1="大";txt2="畜";
      txt3="利贞。不家食吉。利涉大川。";
      txt4="忧愁常锁两眉间，千头万绪挂心间。从今以后打开阵，任意而行不相干。";
      break;
      case 58: txt1="需";txt2=" ";
      txt3="有孚，光亨。贞吉，利涉大川。";
      txt4="明珠土埋日久深，无光无毫到如今。忽然大风吹去土，自然显露又重新。";
      break;
      case 59: txt1="小";txt2="畜";
      txt3="亨。密云不雨。自我西郊。";
      txt4="浓云密排下雨难，盼望行人不见还。交易出行空费力，婚姻求谋是枉然。";
      break;
      case 60: txt1="大";txt2="壮";
      txt3="利贞。";
      txt4="卦占工师得大木，眼前该着走上路。时来运转多顺当，有事自管放心做。";
      break;
      case 61: txt1="大";txt2="有";
      txt3="元亨。";
      txt4="砍树摸雀做事牢，是非口舌自然消。婚姻合伙不费力，若问走失未脱逃。";
      break;
      case 62: txt1="夬";txt2=" ";
      txt3="扬于王庭，孚号。有厉，告自邑。不利即戎，利有攸往。";
      txt4="游蜂脱网喜无边，添财进口福禄连。外则通达内则顺，富贵荣华胜以前。";
      break;
      case 63: txt1="乾";txt2=" ";
      txt3="元亨，利贞。";
      txt4="困龙得水好运交，不由喜气上眉梢。一切谋望皆如意，向后时运渐渐高。";
      break;
      default: txt1=" ";txt2=" ";
      txt3=" ";
      break;
     }

   clr=clrDarkGray;

   ObjectCreate("gN",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet("gN",OBJPROP_XDISTANCE,10);
   ObjectSet("gN",OBJPROP_YDISTANCE,50);
   ObjectSetText("gN",txt1+txt2,60,"Arial Narrow",clr);
   ObjectCreate("gc1",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet("gc1",OBJPROP_XDISTANCE,10);
   ObjectSet("gc1",OBJPROP_YDISTANCE,140);
   ObjectSetText("gc1",txt3,12,"Arial Narrow",clr);
   ObjectCreate("gc2",OBJ_LABEL,0,TimeCurrent(),0,0);
   ObjectSet("gc2",OBJPROP_XDISTANCE,10);
   ObjectSet("gc2",OBJPROP_YDISTANCE,160);
   ObjectSetText("gc2",txt4,12,"Arial Narrow",clr);

   clr=Red;
   yao1Name="yao1-"+IntegerToString(guaNo);
   yao2Name="yao2-"+IntegerToString(guaNo);
   yao3Name="yao3-"+IntegerToString(guaNo);
   yao4Name="yao4-"+IntegerToString(guaNo);
   yao5Name="yao5-"+IntegerToString(guaNo);
   yao6Name="yao6-"+IntegerToString(guaNo);
   if(ObjectFind(yao1Name+"-1")>=0)
     {
      ObjectSet(yao1Name+"-1",OBJPROP_COLOR,clr);
      ObjectSet(yao1Name+"-2",OBJPROP_COLOR,clr);
      ObjectSet(yao1Name+"-3",OBJPROP_COLOR,clr);
      ObjectSet(yao2Name+"-1",OBJPROP_COLOR,clr);
      ObjectSet(yao2Name+"-2",OBJPROP_COLOR,clr);
      ObjectSet(yao2Name+"-3",OBJPROP_COLOR,clr);
      ObjectSet(yao3Name+"-1",OBJPROP_COLOR,clr);
      ObjectSet(yao3Name+"-2",OBJPROP_COLOR,clr);
      ObjectSet(yao3Name+"-3",OBJPROP_COLOR,clr);
      ObjectSet(yao4Name+"-1",OBJPROP_COLOR,clr);
      ObjectSet(yao4Name+"-2",OBJPROP_COLOR,clr);
      ObjectSet(yao4Name+"-3",OBJPROP_COLOR,clr);
      ObjectSet(yao5Name+"-1",OBJPROP_COLOR,clr);
      ObjectSet(yao5Name+"-2",OBJPROP_COLOR,clr);
      ObjectSet(yao5Name+"-3",OBJPROP_COLOR,clr);
      ObjectSet(yao6Name+"-1",OBJPROP_COLOR,clr);
      ObjectSet(yao6Name+"-2",OBJPROP_COLOR,clr);
      ObjectSet(yao6Name+"-3",OBJPROP_COLOR,clr);

     }

   return(0);

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

   if(rates_total<=atrPeriod || atrPeriod<=0)
      return(0);
   if(ChartPeriod(0)!=PERIOD_M5)
     {
      if(ObjectFind(0,"running")<0)
        {
         ObjectCreate("running",OBJ_LABEL,0,TimeCurrent(),0,0);
         ObjectSet("running",OBJPROP_XDISTANCE,360);
         ObjectSet("running",OBJPROP_YDISTANCE,360);
         ObjectSetText("running","只能运行在时间框架:M5!",20,"Arial Narrow",clrRed);
        }
      return(0);
     }

   int limit=rates_total-prev_calculated;
   if(prev_calculated>0)
      limit++;
   for(int i=0; i<limit; i++)
     {
      buf1[i]=iMA(NULL,0,atrPeriod,0,MODE_LWMA,PRICE_MEDIAN,i);
      Gua(i);
      if(i==0)
        {
         DrawRect();
         CurrentGua(i);
        }
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+
