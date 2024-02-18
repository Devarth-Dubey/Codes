
import java.util.Scanner;
class day{
  int t=0;
  int e;
day(int d1,int d2,int d3){
    int u=d1%7;
    int w;
    for(int d0=1;d0<d2;d0++){
        if(d0==1||d0==3||d0==5||d0==7||d0==8||d0==10||d0==12){
          w=3; t=t+w;}
          else if(d0==4||d0==6||d0==9||d0==11){
            w=2; t=t+w;}
          else{
            if(d0==2&&d3%4==0||d0==2&&d3%400==0){
              w=1; t=+1;}
            else{
              w=0;t=t+0; }
          }
    }
    int i=0;
    int r= (d3-1)%400;
    if(r<100){ i=r+r/4;}
    else if(r==100){
      i=5;}
    else  if(r<200&&r>100){
      i=5+(r-100)/4+(r-100);}
    else if(i==200){
      i=3;}
    else if(r<300&&r>200){
      i=3+(r-200)+(r-200)/4;}
    else if(i==300){
      i=1;}
    else if(r<400&&r>300){
      i=1+(r-300)+(r-300)/4;}
    else{
      i=0;}
    e=(u+t+i)%7;
    call();
  } 
  void call(){
        
    if(e==0){
    System.out.print("The day is Sunday");}
    else if(e==1){
    System.out.print("The day is Monday");}
    else if(e==2){
    System.out.print("The day is Tuesday");}
    else if(e==3){
    System.out.print("The day is Wednesday");}
    else if (e==4) {
    System.out.print("The day is Thursday");}
    else if(e==5){
    System.out.print("The day is Friday");}
    else if(e==6){
      System.out.print("The day is Saturday");}
    }
  }

public class Calander{

public static void main(String[] args) {
    
    System.out.println();
    System.out.print("Enter the date : ");
    Scanner d=new Scanner(System.in);
    int d1=d.nextInt();
    System.out.println();
    System.out.print("Enter the mounth number: ");
    int d2=d.nextInt();
    System.out.println();
    System.out.print("Enter the year: ");
    int d3=d.nextInt();
    System.out.println();
    d.close();
    if(d1>=0&&d2>=0&&d2<=12&&d3>=0){
       new day(d1,d2,d3); 
      }
    else System.out.println("Error in data");
      }
}





    
