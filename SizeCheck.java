import java.io.*;

public class SizeCheck {

	public static void main(String[] args) throws Exception {

		BufferedReader br = new BufferedReader(new FileReader(args[0])); 
		BufferedWriter out = new BufferedWriter(new FileWriter(args[0]+".ok"));
		BufferedWriter err = new BufferedWriter(new FileWriter(args[0]+".err"));

		while(br.ready()) {
			String line = br.readLine();	
			String[] parts = line.split("\t");
			try {
				String path = parts[0].substring(1,parts[0].length()-1);
				System.out.println(path);
				File file = new File(path);
				if (file.exists()) {
					out.write(path+"\n");
				} else {
					err.write(path+"\n");
				}

			} catch (Exception e) {
				System.out.println("Failed to parse \""+line+"\"");
			}
		}
		br.close();
	}
}
