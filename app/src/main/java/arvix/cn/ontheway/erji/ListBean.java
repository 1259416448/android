package arvix.cn.ontheway.erji;

import java.util.List;

/**
 * Created by Administrator on 2017/11/3.
 */

public class ListBean {

    /**
     * body : [{"hasChildren":true,"weight":4,"ifShow":true,"ifTop":true,"iconStrAndroid":"fx_cy_bg","dateCreated":1503738114000,"iconStr":"fx_cy_bg","children":[{"hasChildren":false,"weight":3,"ifShow":true,"parentId":1,"ifTop":true,"iconStrAndroid":"fx_zizhucan","lastUpdated":1503739002000,"dateCreated":1503738241000,"iconStr":"fx_zizhucan","name":"自助餐","typeId":2,"colorCode":"E52C2C","id":2},{"hasChildren":false,"weight":2,"ifShow":true,"parentId":1,"ifTop":true,"iconStrAndroid":"fx_kafei","lastUpdated":1503738957000,"dateCreated":1503738288000,"iconStr":"fx_kafei","name":"咖啡","typeId":3,"colorCode":"E52C2C","id":3},{"hasChildren":false,"weight":1,"ifShow":true,"parentId":1,"ifTop":true,"iconStrAndroid":"fx_huoguo","lastUpdated":1503738942000,"dateCreated":1503738313000,"iconStr":"fx_huoguo","name":"火锅","typeId":4,"colorCode":"E52C2C","id":4}],"name":"餐饮","typeId":1,"colorCode":"E52C2C","id":1},{"hasChildren":true,"weight":3,"ifShow":true,"ifTop":true,"iconStrAndroid":"fx_sd_bg","dateCreated":1509504840000,"iconStr":"fx_sd_bg","children":[{"hasChildren":false,"weight":3,"ifShow":true,"parentId":8,"ifTop":true,"iconStrAndroid":"fx_gouwu","dateCreated":1509504938000,"iconStr":"fx_gouwu","name":"商店","typeId":9,"colorCode":"E53DB2","id":9},{"hasChildren":false,"weight":2,"ifShow":true,"parentId":8,"ifTop":true,"iconStrAndroid":"fx_shudian","dateCreated":1509504966000,"iconStr":"fx_shudian","name":"书店","typeId":10,"colorCode":"E53DB2","id":10},{"hasChildren":false,"weight":1,"ifShow":true,"parentId":8,"ifTop":true,"iconStrAndroid":"fx_bianlidian","dateCreated":1509505001000,"iconStr":"fx_bianlidian","name":"便利店","typeId":11,"colorCode":"E53DB2","id":11}],"name":"商店","typeId":8,"colorCode":"E53DB2","id":8},{"hasChildren":true,"weight":2,"ifShow":true,"ifTop":true,"iconStrAndroid":"fx_wy_bg","dateCreated":1509505406000,"iconStr":"fx_wy_bg","children":[{"hasChildren":false,"weight":2,"ifShow":true,"parentId":12,"ifTop":true,"iconStrAndroid":"fx_dianyingyuan","dateCreated":1509505472000,"iconStr":"fx_dianyingyuan","name":"电影院","typeId":13,"colorCode":"6DC73F","id":13},{"hasChildren":false,"weight":1,"ifShow":true,"parentId":12,"ifTop":true,"iconStrAndroid":"fx_bowuguan","dateCreated":1509505506000,"iconStr":"fx_bowuguan","name":"博物馆","typeId":14,"colorCode":"6DC73F","id":14}],"name":"文娱","typeId":12,"colorCode":"6DC73F","id":12},{"hasChildren":true,"weight":0,"ifShow":true,"ifTop":true,"iconStrAndroid":"fx_jt_bg","dateCreated":1503738417000,"iconStr":"fx_jt_bg","children":[{"hasChildren":false,"weight":4,"ifShow":true,"parentId":5,"ifTop":true,"iconStrAndroid":"fx_bashi","lastUpdated":1503738526000,"dateCreated":1503738486000,"iconStr":"fx_bashi","name":"巴士","typeId":6,"colorCode":"2A91F0","id":6},{"hasChildren":false,"weight":3,"ifShow":true,"parentId":5,"ifTop":true,"iconStrAndroid":"fx_zditie","lastUpdated":1503739083000,"dateCreated":1503738555000,"iconStr":"fx_ditie","name":"地铁","typeId":7,"colorCode":"2A91F0","id":7},{"hasChildren":false,"weight":1,"ifShow":true,"parentId":5,"ifTop":true,"iconStrAndroid":"fx_chuzu","dateCreated":1509505597000,"iconStr":"fx_chuzu","name":"出租","typeId":15,"colorCode":"2A91F0","id":15},{"hasChildren":false,"weight":1,"ifShow":true,"parentId":5,"ifTop":true,"iconStrAndroid":"fx_feiji","dateCreated":1509505624000,"iconStr":"fx_feiji","name":"飞机","typeId":16,"colorCode":"2A91F0","id":16}],"name":"交通","typeId":5,"colorCode":"2A91F0","id":5}]
     * code : 0
     * message : fetch.success
     * messageCode : fetch.success
     * serverTime : 1509700009619
     */

    private int code;
    private String message;
    private String messageCode;
    private long serverTime;
    private List<BodyBean> body;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getMessageCode() {
        return messageCode;
    }

    public void setMessageCode(String messageCode) {
        this.messageCode = messageCode;
    }

    public long getServerTime() {
        return serverTime;
    }

    public void setServerTime(long serverTime) {
        this.serverTime = serverTime;
    }

    public List<BodyBean> getBody() {
        return body;
    }

    public void setBody(List<BodyBean> body) {
        this.body = body;
    }

    public static class BodyBean {
        /**
         * hasChildren : true
         * weight : 4
         * ifShow : true
         * ifTop : true
         * iconStrAndroid : fx_cy_bg
         * dateCreated : 1503738114000
         * iconStr : fx_cy_bg
         * children : [{"hasChildren":false,"weight":3,"ifShow":true,"parentId":1,"ifTop":true,"iconStrAndroid":"fx_zizhucan","lastUpdated":1503739002000,"dateCreated":1503738241000,"iconStr":"fx_zizhucan","name":"自助餐","typeId":2,"colorCode":"E52C2C","id":2},{"hasChildren":false,"weight":2,"ifShow":true,"parentId":1,"ifTop":true,"iconStrAndroid":"fx_kafei","lastUpdated":1503738957000,"dateCreated":1503738288000,"iconStr":"fx_kafei","name":"咖啡","typeId":3,"colorCode":"E52C2C","id":3},{"hasChildren":false,"weight":1,"ifShow":true,"parentId":1,"ifTop":true,"iconStrAndroid":"fx_huoguo","lastUpdated":1503738942000,"dateCreated":1503738313000,"iconStr":"fx_huoguo","name":"火锅","typeId":4,"colorCode":"E52C2C","id":4}]
         * name : 餐饮
         * typeId : 1
         * colorCode : E52C2C
         * id : 1
         */

        private boolean hasChildren;
        private int weight;
        private boolean ifShow;
        private boolean ifTop;
        private String iconStrAndroid;
        private long dateCreated;
        private String iconStr;
        private String name;
        private int typeId;
        private String colorCode;
        private int id;
        private List<ChildrenBean> children;

        public boolean isHasChildren() {
            return hasChildren;
        }

        public void setHasChildren(boolean hasChildren) {
            this.hasChildren = hasChildren;
        }

        public int getWeight() {
            return weight;
        }

        public void setWeight(int weight) {
            this.weight = weight;
        }

        public boolean isIfShow() {
            return ifShow;
        }

        public void setIfShow(boolean ifShow) {
            this.ifShow = ifShow;
        }

        public boolean isIfTop() {
            return ifTop;
        }

        public void setIfTop(boolean ifTop) {
            this.ifTop = ifTop;
        }

        public String getIconStrAndroid() {
            return iconStrAndroid;
        }

        public void setIconStrAndroid(String iconStrAndroid) {
            this.iconStrAndroid = iconStrAndroid;
        }

        public long getDateCreated() {
            return dateCreated;
        }

        public void setDateCreated(long dateCreated) {
            this.dateCreated = dateCreated;
        }

        public String getIconStr() {
            return iconStr;
        }

        public void setIconStr(String iconStr) {
            this.iconStr = iconStr;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getTypeId() {
            return typeId;
        }

        public void setTypeId(int typeId) {
            this.typeId = typeId;
        }

        public String getColorCode() {
            return colorCode;
        }

        public void setColorCode(String colorCode) {
            this.colorCode = colorCode;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public List<ChildrenBean> getChildren() {
            return children;
        }

        public void setChildren(List<ChildrenBean> children) {
            this.children = children;
        }

        public static class ChildrenBean {
            /**
             * hasChildren : false
             * weight : 3
             * ifShow : true
             * parentId : 1
             * ifTop : true
             * iconStrAndroid : fx_zizhucan
             * lastUpdated : 1503739002000
             * dateCreated : 1503738241000
             * iconStr : fx_zizhucan
             * name : 自助餐
             * typeId : 2
             * colorCode : E52C2C
             * id : 2
             */

            private boolean hasChildren;
            private int weight;
            private boolean ifShow;
            private int parentId;
            private boolean ifTop;
            private String iconStrAndroid;
            private long lastUpdated;
            private long dateCreated;
            private String iconStr;
            private String name;
            private int typeId;
            private String colorCode;
            private int id;

            public boolean isHasChildren() {
                return hasChildren;
            }

            public void setHasChildren(boolean hasChildren) {
                this.hasChildren = hasChildren;
            }

            public int getWeight() {
                return weight;
            }

            public void setWeight(int weight) {
                this.weight = weight;
            }

            public boolean isIfShow() {
                return ifShow;
            }

            public void setIfShow(boolean ifShow) {
                this.ifShow = ifShow;
            }

            public int getParentId() {
                return parentId;
            }

            public void setParentId(int parentId) {
                this.parentId = parentId;
            }

            public boolean isIfTop() {
                return ifTop;
            }

            public void setIfTop(boolean ifTop) {
                this.ifTop = ifTop;
            }

            public String getIconStrAndroid() {
                return iconStrAndroid;
            }

            public void setIconStrAndroid(String iconStrAndroid) {
                this.iconStrAndroid = iconStrAndroid;
            }

            public long getLastUpdated() {
                return lastUpdated;
            }

            public void setLastUpdated(long lastUpdated) {
                this.lastUpdated = lastUpdated;
            }

            public long getDateCreated() {
                return dateCreated;
            }

            public void setDateCreated(long dateCreated) {
                this.dateCreated = dateCreated;
            }

            public String getIconStr() {
                return iconStr;
            }

            public void setIconStr(String iconStr) {
                this.iconStr = iconStr;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public int getTypeId() {
                return typeId;
            }

            public void setTypeId(int typeId) {
                this.typeId = typeId;
            }

            public String getColorCode() {
                return colorCode;
            }

            public void setColorCode(String colorCode) {
                this.colorCode = colorCode;
            }

            public int getId() {
                return id;
            }

            public void setId(int id) {
                this.id = id;
            }
        }
    }
}
