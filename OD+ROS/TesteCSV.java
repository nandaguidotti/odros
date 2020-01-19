import java.io.*;
import java.util.Arrays;

class TesteCSV {

    private static final String VIRGULA = ",";

    public static void main(String[] args) throws Exception {
    
    String arquivo = "";
        
        BufferedReader reader = new BufferedReader(new InputStreamReader
        (new FileInputStream(arquivo)));
        


String linha = null;        
        while ((linha = reader.readLine()) != null) {
            String[] dadosUsuario = linha.split(VIRGULA);
            System.out.println(Arrays.toString(dadosUsuario));
            System.out.println("Nome: " + dadosUsuario[0]);
            System.out.println("País: " + dadosUsuario[1]);
            System.out.println("Fórum: " + dadosUsuario[2]);
            System.out.println("--------------------------");
        }
        reader.close();
    }
}
    
    
    

