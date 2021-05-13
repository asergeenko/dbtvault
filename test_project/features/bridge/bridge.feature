@fixture.set_workdir
Feature: Bridge

####################### BASE LOAD #######################

# ------------------------ ONE LINK ------------------------
  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and one link with the AS_OF date and LDTS equal
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and one link with AS_OF dates in the past
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-02 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-30 00:00:00.000 |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 12:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-02 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-02 12:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-02 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-02 12:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-02 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 12:00:00.000 | 2018-06-02 12:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and one link with AS_OF dates in the future
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-02 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-03 00:00:00.000 |
      | 2018-06-04 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 12:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-02 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-02 12:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-02 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-02 12:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-02 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 12:00:00.000 | 2018-06-02 12:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-03 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-04 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and one link with multiple loads and an encompassing range of AS OF dates
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 201      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 301      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|301') | md5('1003') | md5('301') | 2018-06-01 12:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|301') | md5('1003') | md5('301') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|201')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|301')     | 9999-12-31 23:59:59.999        |

# ------------------------ TWO LINKS ------------------------
  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and two links with the AS_OF date and LDTS equal
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and two links with AS_OF dates in the past
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-30 00:00:00.000 |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and two links with AS_OF dates in the future
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and two links with multiple loads and an encompassing range of AS_OF dates
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAB')    | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and two links with history and encompassing range of AS_OF dates
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 09:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

# ------------------------ THREE LINKS ------------------------
  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and three links with the AS_OF date and LDTS equal
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_PRODUCT_COMPONENT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK | COMPONENT_FK | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB') | md5('BBB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC') | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD') | md5('DDD-0') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK | COMPONENT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB') | md5('BBB-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC') | md5('CCC-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD') | md5('DDD-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE | LINK_PRODUCT_COMPONENT_PK | EFF_SAT_PRODUCT_COMPONENT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAA')       | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-0\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       | md5('CCC-0\|\|CCC')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and three links with the AS_OF dates in the past
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_PRODUCT_COMPONENT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK | COMPONENT_FK | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB') | md5('BBB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC') | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD') | md5('DDD-0') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK | COMPONENT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB') | md5('BBB-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC') | md5('CCC-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD') | md5('DDD-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE | LINK_PRODUCT_COMPONENT_PK | EFF_SAT_PRODUCT_COMPONENT_ENDDATE |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and three links with the AS_OF dates in the future
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_PRODUCT_COMPONENT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 12:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 23:59:59.999 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 23:59:59.999 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 23:59:59.999 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
    Then the LINK_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK | COMPONENT_FK | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB') | md5('BBB-0') | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC') | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD') | md5('DDD-0') | 2018-06-01 23:59:59.999 | *      |
    Then the EFF_SAT_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK | COMPONENT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB') | md5('BBB-0') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC') | md5('CCC-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD') | md5('DDD-0') | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE | LINK_PRODUCT_COMPONENT_PK | EFF_SAT_PRODUCT_COMPONENT_ENDDATE |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAA')       | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-0\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       | md5('CCC-0\|\|CCC')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and three links with history only in EFF_SAT_ORDER_PRODUCT and encompassing range of AS_OF dates
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCB        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-2        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCA-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCB-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCB-2        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_PRODUCT_COMPONENT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 09:00:00.000 | *      |
      | md5('300\|\|CCB')  | md5('300') | md5('CCB')  | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('300\|\|CCB')  | md5('300') | md5('CCB')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK  | COMPONENT_FK | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA')  | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAB-0\|\|AAB')  | md5('AAB')  | md5('AAB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAA') | md5('AAAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-2\|\|AAAB') | md5('AAAB') | md5('AAA-2') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB')  | md5('BBB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCA-0\|\|CCA')  | md5('CCA')  | md5('CCA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCA-1\|\|CCA')  | md5('CCA')  | md5('CCA-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCB-0\|\|CCB')  | md5('CCB')  | md5('CCB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCB-1\|\|CCB')  | md5('CCB')  | md5('CCB-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCB-2\|\|CCB')  | md5('CCB')  | md5('CCB-2') | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD')  | md5('DDD-0') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK  | COMPONENT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA')  | md5('AAA-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAB-0\|\|AAB')  | md5('AAB')  | md5('AAB-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAA') | md5('AAAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-2\|\|AAAB') | md5('AAAB') | md5('AAA-2') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB')  | md5('BBB-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCA-0\|\|CCA')  | md5('CCA')  | md5('CCA-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCA-1\|\|CCA')  | md5('CCA')  | md5('CCA-1') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCB-0\|\|CCB')  | md5('CCB')  | md5('CCB-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCB-1\|\|CCB')  | md5('CCB')  | md5('CCB-1') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCB-2\|\|CCB')  | md5('CCB')  | md5('CCB-2') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD')  | md5('DDD-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE | LINK_PRODUCT_COMPONENT_PK | EFF_SAT_PRODUCT_COMPONENT_ENDDATE |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-0\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAA')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       | md5('AAB-0\|\|AAB')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-0\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAA')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       | md5('AAB-0\|\|AAB')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-0\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCB')     | 9999-12-31 23:59:59.999       | md5('CCB-0\|\|CCB')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCB')     | 9999-12-31 23:59:59.999       | md5('CCB-1\|\|CCB')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCB')     | 9999-12-31 23:59:59.999       | md5('CCB-2\|\|CCB')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and three links with history only in EFF_SAT_PRODUCT_COMPONENT and encompassing range of AS_OF dates
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAA        | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | AAB        | AAB-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAB       | AAA-2        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-3        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | BBB        | BBB-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-3        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_PRODUCT_COMPONENT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 06:00:00.000 | 2018-06-01 06:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 06:00:00.000 | 2018-06-01 06:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK  | COMPONENT_FK | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA')  | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAA')  | md5('AAA')  | md5('AAA-1') | 2018-06-01 12:00:00.000 | *      |
      | md5('AAB-0\|\|AAB')  | md5('AAB')  | md5('AAB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAB-1\|\|AAB')  | md5('AAB')  | md5('AAB-1') | 2018-06-01 18:00:00.000 | *      |
      | md5('AAB-2\|\|AAB')  | md5('AAB')  | md5('AAB-2') | 2018-06-01 18:00:00.000 | *      |
      | md5('AAA-0\|\|AAAA') | md5('AAAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-2\|\|AAAB') | md5('AAAB') | md5('AAA-2') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-3\|\|AAAB') | md5('AAAB') | md5('AAA-3') | 2018-06-01 12:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB')  | md5('BBB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-1\|\|BBB')  | md5('BBB')  | md5('BBB-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-2\|\|BBB')  | md5('BBB')  | md5('BBB-2') | 2018-06-01 12:00:00.000 | *      |
      | md5('BBB-3\|\|BBB')  | md5('BBB')  | md5('BBB-3') | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-1\|\|CCC')  | md5('CCC')  | md5('CCC-1') | 2018-06-01 09:00:00.000 | *      |
      | md5('CCC-2\|\|CCC')  | md5('CCC')  | md5('CCC-2') | 2018-06-01 18:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD')  | md5('DDD-0') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK  | COMPONENT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA')  | md5('AAA-0') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAA')  | md5('AAA')  | md5('AAA-1') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('AAB-0\|\|AAB')  | md5('AAB')  | md5('AAB-0') | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAB-1\|\|AAB')  | md5('AAB')  | md5('AAB-1') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('AAB-2\|\|AAB')  | md5('AAB')  | md5('AAB-2') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('AAA-0\|\|AAAA') | md5('AAAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-2\|\|AAAB') | md5('AAAB') | md5('AAA-2') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('AAA-3\|\|AAAB') | md5('AAAB') | md5('AAA-3') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB')  | md5('BBB-0') | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-1\|\|BBB')  | md5('BBB')  | md5('BBB-1') | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-1\|\|BBB')  | md5('BBB')  | md5('BBB-1') | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 06:00:00.000 | 2018-06-01 06:00:00.000 | *      |
      | md5('BBB-2\|\|BBB')  | md5('BBB')  | md5('BBB-2') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('BBB-3\|\|BBB')  | md5('BBB')  | md5('BBB-3') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('CCC-1\|\|CCC')  | md5('CCC')  | md5('CCC-1') | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('CCC-1\|\|CCC')  | md5('CCC')  | md5('CCC-1') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('CCC-2\|\|CCC')  | md5('CCC')  | md5('CCC-2') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD')  | md5('DDD-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE | LINK_PRODUCT_COMPONENT_PK | EFF_SAT_PRODUCT_COMPONENT_ENDDATE |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAB')    | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAAB')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAB')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAB')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAB')    | 9999-12-31 23:59:59.999       | md5('AAA-3\|\|AAAB')      | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-2\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-3\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAA')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       | md5('AAB-1\|\|AAB')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       | md5('AAB-2\|\|AAB')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAB')    | 9999-12-31 23:59:59.999       | md5('AAA-0\|\|AAAB')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAB')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAB')      | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAB')    | 9999-12-31 23:59:59.999       | md5('AAA-3\|\|AAAB')      | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-2\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-3\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       | md5('CCC-0\|\|CCC')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       | md5('CCC-1\|\|CCC')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       | md5('CCC-2\|\|CCC')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table from one hub and three links with history in EFF_SAT_ORDER_PRODUCT and EFF_SAT_PRODUCT_COMPONENT, and encompassing range of AS_OF dates
    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCB        | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | 300      | CCB        | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAA        | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | AAB        | AAB-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-2        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-0        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-3        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | BBB        | BBB-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-3        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | CCA        | CCC-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCC-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | CCB        | CCC-1        | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | CCB        | CCC-0        | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_PRODUCT_COMPONENT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 06:00:00.000 | 2018-06-01 06:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.001 | 2018-06-01 18:00:00.001 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 12:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 09:00:00.000 | *      |
      | md5('300\|\|CCB')  | md5('300') | md5('CCB')  | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAB') | md5('101') | md5('AAAB') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 06:00:00.000 | 2018-06-01 06:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCB')  | md5('300') | md5('CCB')  | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('300\|\|CCB')  | md5('300') | md5('CCB')  | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.001 | 2018-06-01 18:00:00.001 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK  | COMPONENT_FK | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA')  | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAA')  | md5('AAA')  | md5('AAA-1') | 2018-06-01 12:00:00.000 | *      |
      | md5('AAB-0\|\|AAB')  | md5('AAB')  | md5('AAB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAB-1\|\|AAB')  | md5('AAB')  | md5('AAB-1') | 2018-06-01 18:00:00.000 | *      |
      | md5('AAB-2\|\|AAB')  | md5('AAB')  | md5('AAB-2') | 2018-06-01 18:00:00.000 | *      |
      | md5('AAA-0\|\|AAAA') | md5('AAAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-2\|\|AAAB') | md5('AAAB') | md5('AAA-2') | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-3\|\|AAAB') | md5('AAAB') | md5('AAA-3') | 2018-06-01 12:00:00.001 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB')  | md5('BBB-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-1\|\|BBB')  | md5('BBB')  | md5('BBB-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-2\|\|BBB')  | md5('BBB')  | md5('BBB-2') | 2018-06-01 12:00:00.000 | *      |
      | md5('BBB-3\|\|BBB')  | md5('BBB')  | md5('BBB-3') | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-1\|\|CCC')  | md5('CCC')  | md5('CCC-1') | 2018-06-01 09:00:00.000 | *      |
      | md5('CCC-2\|\|CCC')  | md5('CCC')  | md5('CCC-2') | 2018-06-01 18:00:00.000 | *      |
      | md5('CCC-0\|\|CCA')  | md5('CCA')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-1\|\|CCA')  | md5('CCA')  | md5('CCC-1') | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-2\|\|CCA')  | md5('CCA')  | md5('CCC-2') | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCB')  | md5('CCB')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-1\|\|CCB')  | md5('CCB')  | md5('CCC-1') | 2018-06-01 00:00:00.000 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD')  | md5('DDD-0') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_PRODUCT_COMPONENT table should contain expected data
      | PRODUCT_COMPONENT_PK | PRODUCT_FK  | COMPONENT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('AAA-0\|\|AAA')  | md5('AAA')  | md5('AAA-0') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAA')  | md5('AAA')  | md5('AAA-1') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('AAB-0\|\|AAB')  | md5('AAB')  | md5('AAB-0') | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAB-1\|\|AAB')  | md5('AAB')  | md5('AAB-1') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('AAB-2\|\|AAB')  | md5('AAB')  | md5('AAB-2') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('AAA-0\|\|AAAA') | md5('AAAA') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAA') | md5('AAAA') | md5('AAA-1') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-2\|\|AAAB') | md5('AAAB') | md5('AAA-2') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('AAA-0\|\|AAAB') | md5('AAAB') | md5('AAA-0') | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('AAA-1\|\|AAAB') | md5('AAAB') | md5('AAA-1') | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('AAA-3\|\|AAAB') | md5('AAAB') | md5('AAA-3') | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('BBB-0\|\|BBB')  | md5('BBB')  | md5('BBB-0') | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-1\|\|BBB')  | md5('BBB')  | md5('BBB-1') | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('BBB-1\|\|BBB')  | md5('BBB')  | md5('BBB-1') | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 06:00:00.000 | 2018-06-01 06:00:00.000 | *      |
      | md5('BBB-2\|\|BBB')  | md5('BBB')  | md5('BBB-2') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('BBB-3\|\|BBB')  | md5('BBB')  | md5('BBB-3') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('CCC-1\|\|CCC')  | md5('CCC')  | md5('CCC-1') | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('CCC-0\|\|CCC')  | md5('CCC')  | md5('CCC-0') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('CCC-1\|\|CCC')  | md5('CCC')  | md5('CCC-1') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('CCC-2\|\|CCC')  | md5('CCC')  | md5('CCC-2') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('CCC-0\|\|CCA')  | md5('CCA')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-1\|\|CCA')  | md5('CCA')  | md5('CCC-1') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-2\|\|CCA')  | md5('CCA')  | md5('CCC-2') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('CCC-0\|\|CCB')  | md5('CCB')  | md5('CCC-0') | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-1\|\|CCB')  | md5('CCB')  | md5('CCC-1') | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('CCC-0\|\|CCB')  | md5('CCB')  | md5('CCC-0') | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.001 | 2018-06-01 18:00:00.001 | *      |
      | md5('DDD-0\|\|DDD')  | md5('DDD')  | md5('DDD-0') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE | LINK_PRODUCT_COMPONENT_PK | EFF_SAT_PRODUCT_COMPONENT_ENDDATE |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-2\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-3\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAA')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       | md5('AAB-1\|\|AAB')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       | md5('AAB-2\|\|AAB')       | 9999-12-31 23:59:59.999           |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       | md5('AAA-1\|\|AAAA')      | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-2\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       | md5('BBB-3\|\|BBB')       | 9999-12-31 23:59:59.999           |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCB')     | 9999-12-31 23:59:59.999       | md5('CCC-0\|\|CCB')       | 9999-12-31 23:59:59.999           |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       | md5('DDD-0\|\|DDD')       | 9999-12-31 23:59:59.999           |

####################### INCREMENTAL LOAD #######################

# ------------------------ ONE LINK ------------------------

  # DATES
  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates into an already populated bridge table from one hub and one link
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
    When the RAW_CUSTOMER_ORDER is loaded
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

  # exploration
  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates into an already populated bridge table from one hub and one link
    Given the HUB_CUSTOMER is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    And the LINK_CUSTOMER_ORDER is already populated with data
    And the EFF_SAT_CUSTOMER_ORDER is already populated with data
    And the BRIDGE_CUSTOMER_ORDER is already populated with data

    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
    When the RAW_CUSTOMER_ORDER is loaded
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

