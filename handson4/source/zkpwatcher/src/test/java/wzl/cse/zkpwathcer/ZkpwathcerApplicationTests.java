package wzl.cse.zkpwathcer;

import org.I0Itec.zkclient.ZkClient;
import org.I0Itec.zkclient.serialize.SerializableSerializer;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import wzl.cse.zkpwathcer.entity.ClientInfo;

/* run tests when ZkClientWatcher is not an ApplicationRunner */
@SpringBootTest
class ZkpwathcerApplicationTests {

    @Test
    void replaceHosts() {
        String connectString = "127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183";
        ZkClient zkClient = new ZkClient(connectString, 5000, 5000, new SerializableSerializer());
        System.out.println(zkClient.readData("/hosts/catalogue").toString());
//        zkClient.createPersistent("/hosts/catalogue-db");
        ClientInfo clientInfo = new ClientInfo("172.26.0.3", "catalogue");
        ClientInfo clientInfoDb = new ClientInfo("172.26.0.2", "catalogue-db");
        zkClient.writeData("/hosts/catalogue", clientInfo);
        zkClient.writeData("/hosts/catalogue-db", clientInfoDb);
        zkClient.close();
    }

    @Test
    void addHosts() {
        String connectString = "127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183";
        ZkClient zkClient = new ZkClient(connectString, 5000, 5000, new SerializableSerializer());
        zkClient.createPersistent("/hosts/orders-db");
        ClientInfo clientInfo = new ClientInfo("172.26.0.4", "orders-db");
        zkClient.writeData("/hosts/orders-db", clientInfo);
        zkClient.close();
    }

    @Test
    void deleteHosts() {
        String connectString = "127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183";
        ZkClient zkClient = new ZkClient(connectString, 5000, 5000, new SerializableSerializer());
        zkClient.delete("/hosts/orders-db");
        zkClient.createPersistent("/hosts/orders-db");
        ClientInfo clientInfo = new ClientInfo("172.26.0.4", "orders-db");
        zkClient.writeData("/hosts/orders-db", clientInfo);
        zkClient.close();
    }

}
