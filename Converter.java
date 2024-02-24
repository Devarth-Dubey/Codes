 class Decimal_to_Bianary{
    Decimal_to_Bianary(int a){
       if(a!=0){ final int n;
        for(int i=0;;i++){
            if(Math.pow(2,i)>a){
                n=i;break;
            }
            else if(Math.pow(2,i)==a){
                n=i+1;break;
            }
        }int[] b=new int[n];
        
        int sum=0;
        for (int i = n-1;i>=0; i--) {
            sum +=Math.pow(2,i);
            if(sum<=a){
                b[n-1-i]=1;
            }
            else{
                b[n-1-i]=0;
                sum -=Math.pow(2,i);
            }
        }
    System.out.print("The Bianary form of the Decimal entry is : ");
    for(int x=0;x<n;x++) System.out.print(b[x]);
}
    else System.out.println("The Bianary form of the Decimal entry is : "+0);
 }
}
 class Bianary_to_decimal{
    Bianary_to_decimal(int a){
        int dec=0;
        int c=0;
            int h=a;
            while(h>=1){
                c=c+1;
                h=h/10;
            }
     int b_d[]=new int[c];
        for(int p=0;p<c;p++){
            b_d[p]=a%10;
            a/=10;
        }
        for(int q=0;q<c;q++){
            if(b_d[q]==1){
                dec+=Math.pow(2,q);
            }
            else continue;
        }
        System.out.println("The Decimal form fo the Binary entry is : "+dec);
    }
}
public class Converter {
    public static void main(String[] args) {
        java.util.Scanner sc=new java.util.Scanner(System.in);
        System.out.print("Enter the Bianary number: ");
        int bin=sc.nextInt();
         new Bianary_to_decimal(bin);
        System.out.println("+-----------------------------------------------------------------------------------------------------------------------------+");
        System.out.print("Enter the Decimal number: ");
        int dec=sc.nextInt();
        sc.close();
        new Decimal_to_Bianary(dec); 
    }
    
}
