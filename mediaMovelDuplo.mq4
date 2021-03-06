//+------------------------------------------------------------------+
//|                                              mediaMovelDuplo.mq4 |
//|                                                      Yuri Odilon |
//|                                                   yuriodilon.com |
//+------------------------------------------------------------------+
#property copyright "Yuri Odilon"
#property link      "yuriodilon.com"
#property version   "1.00"
#property strict

#include <gerenciamento.mqh>
#include <sinais.mqh>
#include <funcoesComuns.mqh>

// INFO

extern int MAGICMA = 0001;  //
extern bool operarComprado = true;
extern bool operarVendido = true; 
extern int splippage   = 150;

extern int takeProfit  = 600;
extern int stopLoss    = 300;


// GERENCIAMENTO       SÓ PODE ESCOLHER UM TIPO DE GERENCIAMENTO
extern bool soros            = false;     //  SOROS
extern int  nivelSoros       = 2;        // Nivel do soros; 
extern double loteFixaSoros  = 0.01;     // 

extern bool gale             = false;    // GALE
extern double fatorGale      = 2.3;      // 

extern bool  usarlotePadrao  = true;    // LOTE PADRAO
extern double lotePadrao     = 0.01;      

// CARACTERISTICAS DO SINAL
extern int  periodoMaiordaMedia  = 14; // Periodo Maior da Média
extern int  periodoMenordaMedia  = 7;  // Periodo Menor da Média
extern int  deslocamento         = 0;  // 0 Padrão
extern int  metododaMedia        = 0;   // Método da média padrão 0;
extern int  aplicaraoPreco       = 0;   // padrao 0
extern int  shiftCandle          = 0;   // Shift 


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  
   
   checkForOpen(MAGICMA, 
                operarVendido,
                operarComprado,
                sinalDuploMM(OP_BUY, Symbol(), 0, periodoMaiordaMedia, periodoMenordaMedia, deslocamento, metododaMedia, aplicaraoPreco, shiftCandle),
                sinalDuploMM(OP_SELL, Symbol(), 0, periodoMaiordaMedia, periodoMenordaMedia, deslocamento, metododaMedia, aplicaraoPreco, shiftCandle),
                splippage,
                "EA MM @yuriodilon",
                stopLoss,
                takeProfit);
                
                
   
   
  }
//+------------------------------------------------------------------+


void checkForOpen(int MAGICMA_n, 
                  bool OperarSELL = true,
                  bool OperarBUY = true,
                  bool sinalcomprar = false,
                  bool sinalvender = false,
                  int Slippage = 150,
                  string coment  = "",
                  double Stop = 0,
                  double Take = 0){
                  
  int    res;
  double entrada;

   
   
  if(IsTradeContextBusy()==true)
      return;
  
  
  // tipo de gerenciamento
  
  if(soros == true){
   entrada = gerenciaSoros(MAGICMA_n, nivelSoros, loteFixaSoros);
  }else if(gale == true){
   entrada = gerenciamentoGale(MAGICMA_n, lotePadrao, fatorGale);
  }else if(usarlotePadrao == true){
   entrada = lotePadrao;
  }
  
    
  RefreshRates();
//---- sell conditions
   if(OperarSELL==true){
      if((sinalvender==true) && 
         ((checkOrdermAberta(MAGICMA_n, OP_SELL) == 0) && (checkOrdermAberta(MAGICMA_n, OP_BUY) == 0) )){
         
           res=OrderSend(Symbol(),OP_SELL,entrada,Bid,Slippage,(Bid+Stop*Point),(Bid-Take*Point),coment,MAGICMA_n,0,clrRed);
      }
        
     }
//---- buy conditions
    if(OperarBUY==true){
      if((sinalcomprar==true) && 
         ((checkOrdermAberta(MAGICMA_n, OP_SELL) == 0) && (checkOrdermAberta(MAGICMA_n, OP_BUY) == 0) )){
           res=OrderSend(Symbol(),OP_BUY,entrada,Ask,Slippage,(Ask-Stop*Point),(Ask+Take*Point),coment,MAGICMA_n,0,clrBlue);
        }
     }
  return;
//----
  }  