import com.appcnd.common.cms.manager.CommonCmsManagerApplication;
import com.appcnd.common.cms.manager.dao.DbDao;
import com.appcnd.common.cms.manager.pojo.po.ColumnInfo;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author nihao 2020/12/16
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = CommonCmsManagerApplication.class)
public class TestT {

    @Autowired
    private DbDao dbDao;

    /**
     * "Create Table" -> "CREATE TABLE `tb_main` (
     *   `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
     *   `text` varchar(200) DEFAULT NULL COMMENT '普通文本',
     *   `textarea` varchar(200) DEFAULT NULL COMMENT '多行文本',
     *   `select` int(11) DEFAULT NULL,
     *   PRIMARY KEY (`id`)
     * ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
     */
    @Test
    public void t() {
        Map<String,String> map = dbDao.showTable("test_cms", "tb_main");
        List<ColumnInfo> columnInfoList = dbDao.getTableInfo("test_cms", "tb_main");
        String sql = map.get("Create Table");
        Pattern pattern = Pattern.compile("`[A-Za-z]+` [A-Za-z]+");
        Matcher matcher = pattern.matcher(sql);
        while (matcher.find()) {
            String a = sql.substring(matcher.start(), matcher.end());
            String name = a.substring(1, a.indexOf("` "));
            String type = a.substring(a.indexOf("` ") + 2);
            System.out.println("");
        }

        Pattern patternPri = Pattern.compile("PRIMARY KEY \\(`[A-Za-z]+`\\)");
        Matcher matcherPri = patternPri.matcher(sql);
        System.out.println(map);

        Pattern patternPriExtra = Pattern.compile("`id`.*,");
        Matcher matcherPriExtra = patternPriExtra.matcher(sql);
        System.out.println("");
    }

}
