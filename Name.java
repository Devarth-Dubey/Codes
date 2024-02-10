
public class Name {
        public static void main(String[] args) {
          int n=9;
          System.out.println();
      
          for(int x=0;x<n;x++){
            for(int y=0;y<n;y++){
            if(x==0&&y<(n-1)/2||y==0||x==(n-1)&&y<(n-1)/2||y==(n-1)/2&&x>0&&x<n-1){
              System.out.print(". ");
            }
            else{
              System.out.print("  ");
            } }
            for(int y=0;y<n;y++){
              if(x==0&&y<=(n-1)/2||y==0||x==(n-1)/2&&y<=(n-1)/2||x==n-1&&y<=(n-1)/2){
                System.out.print(". ");
      
              }
              else{
                System.out.print("  ");
              }
             
            }
            for(int y=0;y<n;y++){
              if(y==0&&x<=(n-1)/2||y==n-1&&x<=(n-1)/2||x-y==(n-1)/2||x+y==(n-1)+(n-1)/2){
                System.out.print(". ");
      
              }
              else{
                System.out.print("  ");
              }
            }System.out.print("      ");
           for(int y=0;y<n;y++)
           {
            if(x==0  && y>0 && y<(n-1)/2||y==0 && x>0||y==(n-1)/2 && x>0||x==(n-1)/2&&y<=(n-1)/2)
            {
              System.out.print(". ");
            }
            else{
              System.out.print("  ");
            }
           }
           for(int y=0;y<n;y++)
            {
              if(y==0||x==0&&y<(n-1)/2||x==(n-1)/2&&y<(n-1)/2||y==(n-1)/2&&x>0&&x<(n-1)/2||x-y==(n-1)/2)
              {
                System.out.print(". ");
              }
              else{
                System.out.print("  ");
              }
            }
            for(int y=0;y<n;y++)
            {
              if(x==0||y==(n-1)/2){
                System.out.print(". ");
              }
              else{
                System.out.print("  ");
              }
            }System.out.print("    ");
           for(int y=0;y<n;y++){
            if(y==0||y==(n-1)/2||x==(n-1)/2&&y<=(n-1)/2) System.out.print(". ");
            else System.out.print("  ");
           } 
            System.out.println();
          }
          System.out.println();
          System.out.println();
          int t,r;
          for(t=0;t<n;t++){
            for(r=0;r<n;r++){
              System.out.print("  ");
            }
            for(r=0;r<n;r++){
              if(r==0||r==(n-1)/2&&t>0&&t<n-1||t==0&&r<(n-1)/2||t==n-1&&r<(n-1)/2) System.out.print(". ");
              else System.out.print("  ");
            }
            for(r=0;r<n;r++){
              if(r==0&&t<n-1||r==(n-1)/2&&t<n-1||t==n-1&&r>0&&r<(n-1)/2) System.out.print(". ");
              else System.out.print("  ");
            }
            for(r=0;r<n;r++){
              if(r==0||t==0&&r<(n-1)/2||t==n-1&&r<(n-1)/2||r==(n-1)/2&&t>0&&t!=(n-1)/2&&t<n-1||t==(n-1)/2&&r<(n-1)/2) System.out.print(". ");
              else System.out.print("  ");
            } 
            for(r=0;r<n;r++){
              if(r==0||(t==0||t==(n-1)/2||t==n-1)&&r<=(n-1)/2) System.out.print(". ");
              else System.out.print("  ");
            }
            for(r=0;r<n;r++){
              if(t+r==n-1&&t<=(n-1)/2||t==r&&r<=(n-1)/2||r==(n-1)/2&&t>(n-1)/2) System.out.print(". ");
              else System.out.print("  ");
            }
            System.out.println();
          }
            System.out.println();System.out.println();
          for(int g=0;g<=5;g++){
            System.out.print("Powered by MAMA,DADU and BHALU      ");}
            System.out.println();System.out.println();
          }
        }

