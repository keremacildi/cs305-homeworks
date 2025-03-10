%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex(void);
void yyerror(const char *s);
%}

%token tSTARTMEETING tENDMEETING tSTARTSUBMEETINGS tENDSUBMEETINGS
%token tMEETINGNUMBER tDESCRIPTION tSTARTDATE tSTARTTIME tENDDATE tENDTIME
%token tLOCATIONS tISRECURRING tFREQUENCY tREPETITIONCOUNT
%token tDAILY tWEEKLY tMONTHLY tYEARLY
%token tYES tNO
%token tASSIGN tCOMMA
%token tIDENTIFIER tSTRING tINTEGER tDATE tTIME

%%

program:
      meeting_list
      ;

meeting_list:
      meeting_block
    | meeting_list meeting_block
      ;

meeting_block:
      tSTARTMEETING tSTRING meeting_body tENDMEETING
      ;

meeting_body:
      meetingNumber 
      description 
      startDate 
      startTime 
      endDate 
      endTime 
      locations 
      isRecurring 
      opt_frequency 
      opt_repetition 
      opt_submeetings
      ;

meetingNumber:
      tMEETINGNUMBER tASSIGN tINTEGER
      ;

description:
      tDESCRIPTION tASSIGN tSTRING
      ;

startDate:
      tSTARTDATE tASSIGN tDATE
      ;

startTime:
      tSTARTTIME tASSIGN tTIME
      ;

endDate:
      tENDDATE tASSIGN tDATE
      ;

endTime:
      tENDTIME tASSIGN tTIME
      ;

locations:
      tLOCATIONS tASSIGN identifier_list
      ;

identifier_list:
      tIDENTIFIER
    | identifier_list tCOMMA tIDENTIFIER
      ;

isRecurring:
      tISRECURRING tASSIGN recurring_val
      ;

recurring_val:
      tYES
    | tNO
      ;

opt_frequency:
    | tFREQUENCY tASSIGN frequency_val
    ;

frequency_val:
      tDAILY
    | tWEEKLY
    | tMONTHLY
    | tYEARLY
      ;

opt_repetition:
    | tREPETITIONCOUNT tASSIGN tINTEGER
    ;

opt_submeetings:
    | tSTARTSUBMEETINGS meeting_list tENDSUBMEETINGS
    ;

%%

int main(void) {
    if (yyparse()) {
        printf("ERROR\n");
        return 1;
    } else {
        printf("OK\n");
        return 0;
    }
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
