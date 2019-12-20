package wzl.cse.zkpwathcer.ZkSerializer;
import org.I0Itec.zkclient.IZkChildListener;
import org.I0Itec.zkclient.IZkDataListener;
import org.I0Itec.zkclient.ZkClient;
import org.I0Itec.zkclient.serialize.SerializableSerializer;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.expression.spel.CodeFlow;
import org.springframework.stereotype.Component;
import wzl.cse.zkpwathcer.entity.ClientInfo;

import java.io.*;
import java.net.InetAddress;
import java.util.*;

@Component
public class ZkClientWatcher {//implements ApplicationRunner {

//    @Override
    public void run(ApplicationArguments args) throws Exception {
        // connect to Zookeeper cluster
        String connectString = "172.17.0.1:2181,172.17.0.1:2182,172.17.0.1:2183";
        String hostFile = "/etc/hosts";
//        String connectString = "127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183";
//        String hostFile = "/Users/pro/Documents/sjtu/31/cse/homework/handson4/handson4/mydockerfiles/hosts";
        ZkClient zkClient = new ZkClient(connectString, 5000, 5000, new SerializableSerializer());
        String path = "/hosts";
        if (!zkClient.exists(path)) {
            zkClient.createPersistent(path);
        }

        // write this containers DNS into zookeeper
        String domain = "none";
        InetAddress addr = InetAddress.getLocalHost();
        if (args.getSourceArgs().length != 0)
            domain = args.getSourceArgs()[0];
        String dnsPath = path + "/" + domain;
        ClientInfo clientInfo = new ClientInfo(addr.getHostAddress(), domain);
        if (zkClient.exists(dnsPath))
            zkClient.delete(dnsPath);
        zkClient.createPersistent(dnsPath);
        zkClient.writeData(dnsPath, clientInfo);
        System.err.println("Zookeeper registers:" + addr.getHostAddress()+ " " + domain);

        List<String> childs = zkClient.getChildren(path);

        // watch if new DNS is added
        zkClient.subscribeChildChanges(path, new IZkChildListener() {
            @Override
            public void handleChildChange(String path, List<String> childList) throws Exception {
                for (String child : childList) {
                    System.out.println("new child:" + child);
                    if (!childs.contains(child)) {
                        System.out.println("child not added before" + child);
                        childs.add(child);
                        String childPath = path + "/" + child;
                        zkClient.subscribeDataChanges(childPath, new IZkDataListener() {
                            @Override
                            public void handleDataChange(String dataPath, Object data) throws Exception {
                                ClientInfo childClientInfo = (ClientInfo) data;
                                writeHosts(childClientInfo, hostFile);
                            }
                            @Override
                            public void handleDataDeleted(String dataPath) throws Exception {

                            }
                        });
//                        String childPath = path+"/"+child;
//                        System.out.println("getchildpath" + childPath);
//                        System.out.println("Zookeeper write data for new DNS:" + zkClient.readData(childPath).toString());
//                        System.out.println("start read childpath" + childPath);
//                        ClientInfo childClientInfo = zkClient.readData(childPath);
//                        System.out.println("start write hosts" + childPath);
//                        writeHosts(childClientInfo, hostFile);
//                        System.out.println("finish write hosts" + childPath);

//                        pw.println(zkClient.readData(childPath).toString());
//                        pw.flush();
                    }
                }
//                File f=new File(hostFile);
//                FileWriter fw = new FileWriter(f, true);
//                PrintWriter pw = new PrintWriter(fw);
//                for (String child : childList) {
//                    System.out.println("new child:" + child);
//                    if (!childs.contains(child)) {
//                        System.out.println("child not added before" + child);
//                        childs.add(child);
//                        String childPath = path+"/"+child;
//                        System.out.println("getchildpath" + childPath);
//                        System.out.println("Zookeeper write data for new DNS:" + zkClient.readData(childPath).toString());
//                        System.out.println("start read childpath" + childPath);
//                        ClientInfo childClientInfo = zkClient.readData(childPath);
//                        System.out.println("start write hosts" + childPath);
//                        writeHosts(childClientInfo, hostFile);
//                        System.out.println("finish write hosts" + childPath);
//
////                        pw.println(zkClient.readData(childPath).toString());
////                        pw.flush();
//                    }
//                }
//                pw.close();
//                fw.close();
            }
        });

        // write existed DNS into /etc/hosts and watch them
//        File f=new File(hostFile);
//        FileWriter fw = new FileWriter(f, true);
//        PrintWriter pw = new PrintWriter(fw);
        for (String child : childs) {
            String childPath = path+"/"+child;
            System.err.println("Zookeeper write data:" + childPath + " "+zkClient.readData(childPath).toString());
            ClientInfo childClientInfo = zkClient.readData(childPath);
            writeHosts(childClientInfo, hostFile);
//            pw.println(zkClient.readData(childPath).toString());
//            pw.flush();
            zkClient.subscribeDataChanges(childPath, new IZkDataListener() {
                @Override
                public void handleDataChange(String dataPath, Object data) throws Exception {
                    ClientInfo childClientInfo = (ClientInfo) data;
                    writeHosts(childClientInfo, hostFile);
                }
                @Override
                public void handleDataDeleted(String dataPath) throws Exception {

                }
            });
        }
//        pw.close();
//        fw.close();

        // keep running
        while(true) {
            Thread.sleep(1000);
            System.err.println("Zookeeper watcher running");
        }
    }

    private void writeHosts(ClientInfo childClientInfo, String hostFile) throws IOException {
        String domain = childClientInfo.getDomain();

        File file = new File(hostFile);
        FileInputStream fis = new FileInputStream(file);
        InputStreamReader isr = new InputStreamReader(fis);
        BufferedReader br = new BufferedReader(isr);
        List<String> buf = new LinkedList<>();

        String temp;
        boolean hasDomain = false;
        while ( (temp = br.readLine()) != null) {

            String[] lineArray = temp.split(" ");

            boolean isDomain = (lineArray.length > 1) && lineArray[1].equals(domain);

            if(isDomain){
                buf.add(childClientInfo.getIp() + " "+ domain);
                hasDomain = true;
            }else{
                buf.add(temp);
            }
        }

        if (!hasDomain)
            buf.add(childClientInfo.getIp() + " "+ domain);

        br.close();
        FileOutputStream fos = new FileOutputStream(hostFile);
        PrintWriter pw = new PrintWriter(fos);
        for (String line : buf) {
            pw.println(line);
            pw.flush();
        }
        pw.close();
    }
}