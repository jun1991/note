#  使用spring boot

本章节是介绍如何使用spring boot。蕴含的主题诸如如何构建系统、自动化配置（auto-configuration）和如何去运行你的应用。我们还介绍了一些Spring Boot最佳实践（他仅仅是另外一个你可以使用的库），这仅仅是一些建议，如果使用的话，会使你开发变得更简单一点。

如果你开始使用Spring Boot，你应该在进入这一节之前阅读入门指南。

## 构建系统

这里强烈建议你构建系统的时候能支持[依赖管理（]()dependency management），这可以消费发布到“MavenCentral”仓库的组件。我们推荐你选择Maven或者Gradle。有可能让Spring Boot与其他系统（例如Ant）一起工作，但是它们并不是特别受支持的。

## 依赖管理（dependency management）

Spring Boot的每次发布都提供了一个经过精心编排的依赖项列表.。在实践中，您不需要为构建配置中的任何依赖项提供版本号，Spring Boot会去帮你管理好版本信息。当你更新Spring  Boot版本的时候，这些依赖会跟着一致升级。

注意：如有必要，你依然可以自己指定一个版本来覆盖Spring Boot的推荐版本

这个精选的列表包含了所有可以使用Spring Boot的Spring模块，以及一个精挑细选的第三方库列表。这个列表可以作为标准的依赖列表（spring-boot-dependencies），可以同时使用Maven和Gradle。

警告：Spring Boot的每个版本都与Spring Framework的基本版本相关联。我们强烈建议您不要指定它的版本。

##  Maven

Maven用户可以从spring boot-start-parent项目中继承来获得合理的默认值。父项目规定以下特性:

l  Java1.8 作为默认的编译版本

l  UTF-8为默认编码

l  部分依赖管理，继承自spring-boot-dependenciespom，管理常见依赖项的版本。这种依赖性管理可以让您在自己的pom中不需要配置<version>这个标签

l  合理的资源过滤

l  科学的插件配置（exec plugin,Git commit ID, and shade）

l  合理的资源过滤，例如：application.properties和application.yml；还包含特殊的文件（例如：application-dev.properties 和 application-dev.yml）

注意，application.properties 和 application.yml文件都能解析spring 风格的占位符（${…}），Maven需要将占位符换为@..@。（你可以通过设置一个Maven属性来覆盖它，这个属性是：resource.delimiter）

 

**继承自**** Starter Parent**

将你的项目配置为继承自spring-boot-starter-parent,按照以下方式设置父依赖:

```xml
<!-- Inherit defaults from Spring Boot -->

<parent>

  <groupId>org.springframework.boot</groupId>

  <artifactId>spring-boot-starter-parent</artifactId>

  <version>2.0.3.RELEASE</version>

</parent>

```



 

注意：您应该只需要在这个依赖项上指定Spring Boot版本号。如果你导入额外的starters, 您可以安全地省略版本号。

虽然有了这种配置，但是你依然可以在你的项目中指定个别版本的依赖。例如，升级Spring  Data 为其他的版本，添加如下依赖到你的pom.xml里面即可：

```xml
<properties>                
  <spring-data-releasetrain.version>Fowler-SR2</spring-data-releasetrain.version>
</properties>
```



提示：查看spring-boot-dependencies pom可以看到支持的列表。

 

   **缺少****Parent POM****的方式使用****Spring Boot**

**       **并非所有人都喜欢继承spring-boot-starter-parent POM。你可能有你自己的公司标准的父Pom，你需要使用或者你可能更倾向于明确地声明你所有的Maven配置。

如果你不想使用spring-boot-starter-parent，您仍然可以通过使用scope=import依赖性来保持依赖性管理（而不是插件管理）的好处，如下所列：

```xml
<dependencyManagement>

      <dependencies>

         <dependency>

            <!-- Import dependency management from Spring Boot-->

            <groupId>org.springframework.boot</groupId>

            <artifactId>spring-boot-dependencies</artifactId>

            <version>2.0.3.RELEASE</version>

            <type>pom</type>

            <scope>import</scope>

         </dependency>

      </dependencies>

</dependencyManagement>

```



**前面的示例配置不允许您通过使用属性来覆盖个别依赖项，如上所述。为了达到相同的结果，您需要在spring-boot-dependencies入口之前在项目的dependencyManagement中添加一个配置。例如，升级SpringData版本的时候，你需要在你的pom.xml中添加下面的元素：

```xml
<dependencyManagement>

  <dependencies>

    <!-- Override Spring Data release train provided by Spring Boot -->

    <dependency>

      <groupId>org.springframework.data</groupId>

      <artifactId>spring-data-releasetrain</artifactId>

      <version>Fowler-SR2</version>

      <type>pom</type>

      <scope>import</scope>

    </dependency>

    <dependency>

      <groupId>org.springframework.boot</groupId>

      <artifactId>spring-boot-dependencies</artifactId>

      <version>2.0.3.RELEASE</version>

      <type>pom</type>

      <scope>import</scope>

    </dependency>

  </dependencies>

</dependencyManagement>

```



       注意：在前面的例子中，我们指定了BOM，但是任何依赖类型都可以以相同的方式覆盖。

**使用****Spring Boot Maven Plugin**

Spring Boot提供了一个Maven plugin，可以用它来为项目打出一个可执行jar包。如果你需要使用这个plugin，只需要在<plugins>中添加即可，示例如下所示：

  ```xml
 <!--Package as an executable jar -->

<build>

  <plugins>

    <plugin>

      <groupId>org.springframework.boot</groupId>

      <artifactId>spring-boot-maven-plugin</artifactId>

    </plugin>

  </plugins>

</build>

  ```



注意：如果你使用SpringBoot starter parent pom，你只需要添加插件。不需要配置它，除非您想要更改parent中定义的设置。

## Gradle

## Ant

## Starters

Starters是一组方便使用的依赖，你可以在你的应用中引入并使用它们。你可以为所有的Spring和相关技术提供一站式服务而无需通过样本代码和复制粘贴的依赖去加载。例如，如果你需要使用spring和JPA去操作数据库，只需要在你的项目中引入spring-boot-starter-data-jpa依赖即可。

Starters包含许多依赖项，可以满足您需要快速地启动一个项目并使用一致的、受支持的管理传递依赖关系集。

**命名规则**

所有的官方starters遵循类似的命名规则；spring-boot-starter-*，*标识了特定的应用类型。这种命名规则是为了帮助你快速的找到你需要的starter。Maven在非常多的IDE里面集成了，可以让你根据名字查询依赖。例如，安装了适当插件的Eclipse或STS，你可以在POM编辑器中按ctrl+space键，并键入“spring boot-starter”来获取一个完整的依赖列表。****

正如在“创建您自己的Starts”部分中所解释的那样，第三方的starters不应该使用spring-boot作为前缀，因为它是为官方Spring Boot artifacts预留的。相反，第三方启动器通常以项目的名称开始。例如，一个名为thirdpartyproject的第三方启动项目通常会被命名为thirdpartyproject-sprin-boot-starter。

 

下面的应用程序starters是由Spring Boot在groupId为org.springframework.boot下提供的:

       SpringBoot应用的starters


​       

| 名字                                       | 描述                                       | POM                                      |
| ---------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| spring-boot-starter                      | 核心starter，包括自动配置支持、日志记录和YAML             | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter/pom.xml) |
| spring-boot-starter-activemq             | 使用Apache ActiveMQ的JMS消息传递starter         | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-activemq/pom.xml) |
| spring-boot-starter-amqp                 | 使用了Spring AMQP和Rabbit MQ的starter         | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-amqp/pom.xml) |
| spring-boot-starter-aop                  | 使用Spring Aop和AspectJ实现面向切面编程的starter     | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-artemis/pom.xml) |
| spring-boot-starter-batch                | Spring Batch的starter                     | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-batch/pom.xml) |
| spring-boot-starter-cache                | Spring Framework支持的缓存starter             | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-cache/pom.xml) |
| spring-boot-starter-cloud-connectors     | 使用Spring Cloud的starter，在Cloud Foundry和Heroku等云平台上简化连接到服务的连接器的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-cloud-connectors/pom.xml) |
| spring-boot-starter-data-cassandra       | 使用了Cassandra和Spring Data Cassandra的分布式数据库starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-cassandra/pom.xml) |
| spring-boot-starter-data-cassandra-reactive | 用于使用分布式数据库Cassandra和Spring Data Cassandra Reactive 的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-cassandra-reactive/pom.xml) |
| spring-boot-starter-data-couchbase       | [用于使用基于文档的数据库Couchbase]()和Spring Data Couchbase 的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-cassandra-reactive/pom.xml) |
| spring-boot-starter-data-couchbase-reactive | 用于使用基于文档的数据库Couchbase和Spring Data Couchbase Reactive 的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-couchbase-reactive/pom.xml) |
| spring-boot-starter-data-elasticsearch   | 使用Elasticsearchsearch和Spring Data Elasticsearch实现分析搜索引擎的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-elasticsearch/pom.xml) |
| spring-boot-starter-data-jpa             | 基于Hibernate实现的Spring Data JPA starter    | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-jpa/pom.xml) |
| spring-boot-starter-data-ldap            | Spring Data LDAP的starter                 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-ldap/pom.xml) |
| spring-boot-starter-data-mongodb         | 用于使用基于文档的数据库MongoDB和Spring Data MongoDB 的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-mongodb/pom.xml) |
| spring-boot-starter-data-mongodb-reactive | 用于使用基于文档的数据库MongoDB和Spring Data MongoDB Reactive[的starter]() | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-mongodb-reactive/pom.xml) |
| spring-boot-starter-data-neo4j           | 用于使用图形数据库Neo4j和Spring Data Neo4j的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-neo4j/pom.xml) |
| spring-boot-starter-data-redis           | 用于使用Spring Data Redis和Lettuce客户端操作键-值存储的Redis的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-redis/pom.xml) |
| spring-boot-starter-data-redis-reactive  | 用于使用Spring Data Redis reactive和Lettuce客户端操作键-值存储的Redis的starter | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-redis-reactive/pom.xml) |
| spring-boot-starter-data-rest            | 用于使用Spring Data REST暴露基于REST的Spring Data仓库 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-rest/pom.xml) |
| spring-boot-starter-data-solr            | 通过Spring Data Solr使用Apache Solr搜索平台      | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-data-solr/pom.xml) |
| spring-boot-starter-freemarker           | 用于使用FreeMarker模板引擎构建MVC web应用            | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-freemarker/pom.xml) |
| spring-boot-starter-groovy-templates     | 用于使用Groovy模板引擎构建MVC web应用                | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-groovy-templates/pom.xml) |
| spring-boot-starter-hateoas              | 用于使用Spring MVC和Spring HATEOAS实现基于超媒体的RESTful web应用 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-hateoas/pom.xml) |
| spring-boot-starter-integration          | 用于使用Spring Integration                   | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-integration/pom.xml) |
| spring-boot-starter-jdbc                 | 对JDBC的支持（使用HikariCP连接池）                  | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-jdbc/pom.xml) |
| spring-boot-starter-jersey               | 用于使用JAX-RS和Jersey构建RESTful web应用，可使用spring-boot-starter-web替代 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-jersey/pom.xml) |
| spring-boot-starter-jooq                 | 用于使用JOOQ访问SQL数据库，可使用spring-boot-starter-data-jpa或spring-boot-starter-jdbc替代 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-jooq/pom.xml) |
| spring-boot-starter-json                 | 用于读写json                                 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-json/pom.xml) |
| spring-boot-starter-jta-atomikos         | 用于使用Atomikos实现JTA事务                      | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-jta-atomikos/pom.xml) |
| spring-boot-starter-jta-bitronix         | 用于使用Bitronix实现JTA事务                      | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-jta-bitronix/pom.xml) |
| spring-boot-starter-jta-narayana         | 用于使用Narayana实现JTA事务                      | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-jta-narayana/pom.xml) |
| spring-boot-starter-mail                 | 用于使用Java Mail和Spring Frameworke mail发送支持 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-mail/pom.xml) |
| spring-boot-starter-mustache             | 用于使用Mustache模板引擎构建MVC web应用              | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-mustache/pom.xml) |
| spring-boot-starter-quartz               | 基于Quartz实现的任务调度                          | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-quartz/pom.xml) |
| spring-boot-starter-security             | 对Spring Security的支持                      | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-security/pom.xml) |
| spring-boot-starter-test                 | 用于测试Spring Boot应用，支持常用测试类库，包括JUnit, Hamcrest和Mockito | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-test/pom.xml) |
| spring-boot-starter-thymeleaf            | 用于使用Thymeleaf模板引擎构建MVC web应用             | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-thymeleaf/pom.xml) |
| spring-boot-starter-validation           | 用于使用Hibernate Validator实现Java Bean校验     | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-validation/pom.xml) |
| spring-boot-starter-web                  | 用于使用Spring MVC构建web应用，包括RESTful。Tomcat是默认的内嵌容器 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-web/pom.xml) |
| spring-boot-starter-web-services         | 对Spring Web服务的支持                         | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-web-services/pom.xml) |
| spring-boot-starter-webflux              | 提供用Spring Framework创建webflux应用的支持        | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-webflux/pom.xml) |
| spring-boot-starter-websocket            | 用于使用Spring Framework的WebSocket支持构建WebSocket应用 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-websocket/pom.xml) |

除了应用级别的starters，下面的starters还可以用来添加生产就绪的特性：

Spring Boot生产starters

| spring-boot-starter-actuator | 用于使用Spring Boot的Actuator，它提供了production ready功能来帮助你监控和管理应用程序 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-actuator/pom.xml) |
| ---------------------------- | ---------------------------------------- | ---------------------------------------- |
|                              |                                          |                                          |

最后，Spring Boot还包括以下的starters，如果您想要排除或更换特定方面的技术，可以使用它们：

Spring Boot技术级别的starters

| spring-boot-starter-jetty         | 用于使用Jetty作为内嵌servlet容器，可使用spring-boot-starter-tomcat替代 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-jetty/pom.xml) |
| --------------------------------- | ---------------------------------------- | ---------------------------------------- |
| spring-boot-starter-log4j2        | 用于使用Log4j2记录日志，可使用spring-boot-starter-logging代替 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-log4j2/pom.xml) |
| spring-boot-starter-logging       | 用于使用Logback记录日志，默认的日志starter             | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-logging/pom.xml) |
| spring-boot-starter-reactor-netty | 使用Reactor Netty做为内嵌的HTTP服务器              | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-reactor-netty/pom.xml) |
| spring-boot-starter-tomcat        | 用于使用Tomcat作为内嵌servlet容器，spring-boot-starter-web使用的默认servlet容器 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-tomcat/pom.xml) |
| spring-boot-starter-undertow      | 用于使用Undertow作为内嵌servlet容器，可使用spring-boot-starter-tomcat替代 | [POM](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-starters/spring-boot-starter-undertow/pom.xml) |

 

提示：对于另外一个社区贡献的starters，请参阅GitBub上面的spring-boot-starters模块的[README](https://github.com/spring-projects/spring-boot/blob/master/spring-boot-project/spring-boot-starters/README.adoc)文件。

#  构建你的代码

Spring Boot不需要任何额外的代码就能工作。然而，这里有一些非常好的实践能帮助到你。

## 使用“default”（默认）包

当一个类没有任何的包声明的时候，他就被认为是“default package”(默认包)。通常是不鼓励使用“defaultpackage”的。它可能会给使用@ComponentScan,@EntityScan或者@SpringBootApplication注解的Spring Boot应用程序带来特别的问题，因为每个jar中的每个类都被读取。

提示：我们建议您遵循Java推荐的包命名约定，并使用反向域名（例如：com.example.project）。

## 确定主应用程序类（Main Application Class）

我们通常建议您将主应用程序类放在根包，在所有的其他类之上。@SpringBootApplication注解通常就放在你的main类上，它隐式地为项目定义了一个基本的“search package”（包搜索范围）。例如，如果你写一个JPA的应用程序，@SpringBootApplication注解会被用来搜索所有蕴含@Entity注解的类。使用根包，也就仅仅允许程序扫描你的项目。

 

提示：如果你不愿意使用@SpringBootApplication注解，你也可以引入@EnableAutoConfiguration和@ComponentScan注解来代替，他们定义了同样的行为。

 

下面的清单显示了一个典型的布局：

com

+-  example

+-  myapplication

+-  Application.java

|

+-  customer

|        +-  Customer.java

|       +-  CustomerController.java

|       +-  CustomerService.java

|       +-  CustomerRepository.java

|

+-  order

+-  Order.java

+-  OrderController.java

+-  OrderService.java

+-  OrderRepository.java

Application.java声明了一个主应用程序，包含了一个基本的注解@SpringBootApplication，如下所示：

 

```java
package com.example.myapplication;

 

import org.springframework.boot.SpringApplication;

import org.springframework.boot.autoconfigure.SpringBootApplication;

 

@SpringBootApplication

public class Application {

   public static void main(String[] args) {

      SpringApplication.run(Application.class, args);

   }

}

```



#   配置类（Configuration Classes）

Spring Boot支持基于java的配置类。尽管可以使用SpringApplicationXML的方式，我们通常建议你使用一个@Configuration类去配置。通常main 方法的类是@Configuration类的非常好的候选类。

提示：许多Spring配置示例已经在Internet上发布，它们使用XML配置。如果可能的话，使用等价的基于java的配置去替代。搜索Enable*注解会是一个很好的切入点。

##  引入额外的配置类

你不需要在一个类中完成所有的@Configuration。@Import注解可以引入其他的配置类。你也可以用@ComponentScan注解让Spring自动注入所有的组件，包含@Configuration配置类。

##  引入XML配置

如果你需要使用基于xml的配置。我们建议你依然使用一个包含@Configuration的类，你可以在这个类上通过@ImportResource注解引入你的xml配置文件。

#  自动注入（Auto-configuration）

Spring Boot自动注入试图通过引入jar依赖的方式自动的为你的Spring应用完成配置。例如，你的classpath中有HSQLDB，你就不需要有任何手动配置数据库连接的beans了，Spring Boot的自动注入会自动帮你在内存中完成配置。

你需要在你的@Configuration类中选择自动注入的注解@EnableAutoConfiguration或者@SpringBootApplication。

提示：你仅仅需要引入@SpringBootApplication 或者@EnableAutoConfiguration注解。我们通常建议您仅将一个或另一个添加到主@Configuration类中。

##  逐步更换自动配置

自动注入是非侵入性的。在任何时候，你都可以通过你自定义的配置去替换自动配置的特定部分。例如，如果添加你自定义的DataSource bean，默认的嵌入式的数据库支持就会低于你的优先级。

如果你需要找出当前正在应用的自动配置，和为什么，可以用debug的方式启动你的应用程序。这样做可以为选择的核心loggers启用debug logs，并将条件输出到控制台。

##  禁用特定的自动配置类

如果你需要禁用特定的一系列自动配置类生效，你可以在@EnableAutoConfiguration注解中使用exclude属性去禁用它们，如下示例：

```java
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;

import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

 

@EnableAutoConfiguration(exclude={DataSourceAutoConfiguration.class})

public class MyConfiguration {

 

}

```



 

如果类没有在classpath中找到，你可以使用在注解中使用excludeName属性写上全类名来代替。最后，您还可以使用spring.autoconfigure.exclude属性控制要排除的自动配置类列表。

 

提示：您可以在注释级别和使用属性定义排除项。

# Spring Beans 和 依赖注入（Dependency Injection）

你可以免费使用任何Spring Framework技术去定义你的beans和注入它们的依赖项（injected dependencies）。例如，我们经常使用@ComponentScan（扫描你的beans）和使用@Autowired（作为构造函数注入），它们做的非常好。

如果您按照上面的建议来构造您的代码（在根包中定位您的应用程序类），你需要加入@ComponentScan注解，并且不需要任何参数。你应用程序中所有包含如下注解的组件(@Component,@Service, @Repository, @Controller 等等)都会自动注册成为Spring Beans.

如下例子可以看到@Service Bean可以通过构造函数注入它所需要的RiskAssessor 实体：

```java
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

 

@Service

public class DatabaseAccountService implements AccountService{

   

   private final RiskAssessor riskAssessor;

   

   @Autowired

   public DatabaseAccountService(RiskAssessor riskAssessor) {

      this.riskAssessor = riskAssessor;

   }

}

```



 

如果bean里面只有一个构造函数，你可以省略掉@Autowired注解，代码如下所示：

 

```java
@Service

public class DatabaseAccountService implements AccountService{

   

   private final RiskAssessor riskAssessor;

   

   public DatabaseAccountService(RiskAssessor riskAssessor) {

      this.riskAssessor = riskAssessor;

   }

}

```



提示：注意使用构造函数注入如何将riskAssessor字段标记为final，表明无法随后更改。

# 使用@SpringBootApplication注解

很多Spring Boot开发者喜欢在它们的apps使用自动注入，组件扫描和在它们的“application class”上定义配置。使用一个@SpringBootApplication注解可以实现三个特性，那是：

l  @EnableAutoConfiguration:开启Spring Boot自动配合机制

l  @ComponentScan: 在应用程序所在的包上启用@component扫描（请参阅最佳实践）

l  @Configuration:允许注册特别的beans到上下文或者引入额外的配置类

@SpringBootApplication  注解等价于使用@Configuration、@EnableAutoConfiguration和@ComponentScan注解和它们的默认属性，例子如下所示：

```java
import org.springframework.boot.SpringApplication;

importorg.springframework.boot.autoconfigure.SpringBootApplication;

 

@SpringBootApplication

public class Application {

   public static void main(String[] args) {

      SpringApplication.run(Application.class, args);

   }

}

```



 

注意：@SpringBootApplication提供了别名来为@EnableAutoConfiguration 和 @ComponentScan 定制属性。

 

注意：这些特性都不是强制的，你可以选择任何的特性来替换这个注解。例如，你可以在你的程序不使用自动扫描组件：

```java
import org.springframework.boot.SpringApplication;

importorg.springframework.boot.autoconfigure.EnableAutoConfiguration;

import org.springframework.context.annotation.Configuration;

import org.springframework.context.annotation.Import;

 

@Configuration

@EnableAutoConfiguration

@Import({ MyConfig.class, MyAnotherConfig.class })

public class Application {

   public static void main(String[] args) {

      SpringApplication.run(Application.class, args);

   }

}

```



 

在这个例子里，应用和其他的Spring Boot应用程序一样，只是不自动检查@Component组件，需要用@Import注解来显式指定需要引入的配置。

 

#  启动你的应用程序

将应用程序打包成jar并使用嵌入式HTTP服务器的最大优势之一是，您可以像其他任何应用程序一样运行应用程序。Debugging Spring Boot应用将会变得非常简单，你不需要任何特别的IDE插件和拓展。

 

注意：这部分仅仅是包含基于jar方式打包，如果你需要将你的应用打包成war文件，您应该参考您的服务器和IDE文档。

##  在IDE运行

你可以在你的IDE运行Spring Boot应用就跟运行一个简单的java应用程序一样。当然，首先你得引入的项目，导入步骤取决于您的IDE和构建系统。很多IDE支持直接导入MAVEN项目。例如，Eclipse你可以通过如下步骤引入Import…  → Existing Maven Projectsfrom the File menu。

       如果你不能直接在你的IDE引入项目，您可以通过使用构建插件来生成IDE元数据。Maven包含Eclipse和IDEA的插件。Gradle为各种ide提供插件。

 


提示：如果你意外运行了两次你的web应用，你会看到一个错误“Port already in use”。 STS用户可以使用重启按钮而不是Run按钮来确保任何现有的实例都被关闭。

## 运行一个打包好的应用

如果你使用Spring Boot Maven或者Gradle插件创建了一个可运行jar包，你可以使用java –jar命令运行你的应用，例子如下所示：

```shell
$ java -jartarget/myapplication-0.0.1-SNAPSHOT.jar
```

       还可以使用启用远程调试支持的打包应用程序运行。这样做可以让您将调试器附加到打包的应用程序中，例子如下所示：

```shell
$ java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n\ -jar target/myapplication-0.0.1-SNAPSHOT.jar
```



## 使用Maven Plugin

Spring BootMaven插件包含一个run目标，可以用来快速编译和运行您的应用程序。应用以[exploded]()形式运行，就像在IDE中运行一样。

```shell
$ mvn spring-boot:run
```

 

你可能还想使用MAVEN_OPTS选择操作系统环境变量，如下面的例子所示：

```shell
$ export MAVEN_OPTS=-Xmx1024m
```



##  使用Gradle Plugin

Spring BootGradle插件还包括一个bootRun任务，该任务可用于以exploded的形式运行应用程序。当你如下所示一样引入了org.springframework.boot和java plugins，bootRun任务就会被添加进来：

```shell
$ gradle bootRun
```

你也许还想使用JAVA_OPTS选择你的操作系统环境变量，如下面的例子所示：

```shell
$ export JAVA_OPTS=-Xmx1024m
```

 

 

##  热部署（Hot Swapping）

因为Spring Boot应用程序是一个简单的java应用程序。JVM热交换应该是开箱即用的。JVM热交换可以替换的字节码有限制。一个更全面的解决方案是JRebel。

spring-boot-devtools模块被引入进来可以支持程序快速的重启。

 

#  开发者工具

Spring Boot包含额外的工具集合，可以使应用开发的过程更方便一点。spring-boot-devtools模块可以包含进任何工程，用来提供额外的程序调试特性。为了添加工具支持，简单的添加模块依赖到你的构建系统中：

 

**Maven.**

```xml
<dependencies>

         <dependency>

            <groupId>org.springframework.boot</groupId>

            <artifactId>spring-boot-devtools</artifactId>

            <optional>true</optional>

         </dependency>

</dependencies>
```





**Gradle.**

```groovy
dependencies {

   compile("org.springframework.boot:spring-boot-devtools")

}
```



 

注意：当运行一个完整的打包应用时，开发者工具会自动失效。如果你的程序通过java –jar或者特别的类装载器启动，那它会被当做一个『产品级应用』。在Maven中将依赖性标记为可选的，或者在Gradle中使用compileOnly是一种最佳实践，它可以防止devtools被应用到其他使用项目的模块中。

 

 

提示：再打包文件默认不包含开发者工具。如果你想使用某个远程devtools特性，你需要通过禁用excludeDevtools属性的方式去引入它。这个特性Maven和Gradle plugins都支持。

##  属性默认值

几个libraries都通过Spring Boot使用缓存来提高其性能。例如，template engines缓存编译好的末班来避免反复地编译模板文件。而且，Spring Mvc可以通过添加HTTP缓存响应头的方式来缓存静态资源。

缓存对于生产环境来说是非常有利的，在开发过程中可能会适得其反，会让你不能马上看到你刚刚修过过的程序。基于这个原因，spring-boot-devtools默认是关闭缓存的。

缓存配置往往是通过application.properties文件配置的。例如，Thymeleaf提供spring.thymeleaf.cache属性。而不是手动设置这些属性而不是手动设置这些属性，spring-boot-devtools模块会自动应用合理的开发时间配置。

 

提示: 要获得devtools所应用的属性的完整列表，查看[DevToolsPropertyDefaultsPostProcessor.](https://github.com/spring-projects/spring-boot/blob/v2.0.3.RELEASE/spring-boot-project/spring-boot-devtools/src/main/java/org/springframework/boot/devtools/env/DevToolsPropertyDefaultsPostProcessor.java)

## 自动重启

应用了spring-boot-devtools的程序，当你改变classpath的文件的时候，程序会自动重启。在你的IDE中，这是一个非常有用的特性，因为它提供了一个非常快速的代码变更反馈循环。默认情况下，指向某个文件夹的类路径上的任何条目都会被监控以进行更改。注意，有些静态资源和视图模板，是不需要重启应用的。

> **触发重启**
>
> 当DevTools监听classpath资源时，触发重启的唯一途径就是修改了classpath。您使classpath更新的方式取决于您所使用的IDE。在eclipse的时候，保存一个修改的文件，就会使classpath发生了改变，会触发重启。在IntelliJ IEDA的时候，建立项目也是同样的效果(Build -> Build Project)

> **注意**
>
> 当forking被启用的时候，您还可以使用受支持的构建插件启动应用程序(Maven and Gradle)，因为DevTools需要一个独立的应用程序类加载器才能正常运行。Gradle和Maven默认在classpath让DevTools起作用。

> **提示**
>
> 当使用LiveReload的时候，自动重启会工作得非常好。LiveReload的细节请看LiveReload章节。如果你使用JRebel，自动重启支持动态类重载。其他的devtools特性(例如：LiveReload和属性重写)都能被使用。

> **注意**
>
> DevTools依赖于应用程序上下文的关闭钩子在重新启动时关闭它。如果你关闭了钩子(SpringApplication.setRegisterShutdownHook(false))，它将不能正常工作。

> **注意**
>
> 决定classpath的改变是否会触发重启，DevTools会自动忽略如下命名的项目spring-boot, spring-boot-devtools, spring-boot-autoconfigure, spring-boot-actuator, 和 spring-boot-starter.

> **注意**
>
> 使用ApplicationContext的时候，DevTools需要自定义ResourceLoader。如果你的应用程序已经提供了一个，它将被覆盖。直接重写ApplicationContext的getResource方法是不被支持的。

> **重启vs重新加载**
>
> Spring Bootd的重启技术通过两个类加载器来实现。Classes不发生改变（例如，改变是来自于第三方jars），它们将会被base类加载器加载。您正在开发的类被加载到restart类加载器中。当应用程序重启时，restart类加载器将会被丢弃，重新创建一个新的restart类加载器。这种重启应用程序的方式通常意味着比“cold starts(冷加载)”快得多，因为base类加载器已经可用并且准备好了。
>
> 如果你发现重新启动对于你的应用程序来说不够快或者你遇到了类加载问题，你可以考虑使用JRebel的ZeroTurnaround重新加载技术。通过重写类来使它们更易于重新加载。

###条件评估中记录变更

默认情况下，每当你的应用重启，会有一份报告显示delta状态评估记录。这份报告可以看到你的应用程序的auto-configuration（自动注入）的beans和设置的配置属性的变化情况。

通过如下属性配置，可以关闭报告的日志：

```properties
spring.devtools.restart.log-condition-evaluation-delta=false
```

### 资源排除

某些资源的改变其实是没有必要触发重启的。例如，Thymeleaf模板可以原地编辑。默认情况下，如下资源的改变是不需要触发重启的，它们不在reload的生命周期内的：/META-INF/maven,
/META-INF/resources, /resources, /static, /public, 或者 /templates。如果你需要定制排除的资源，你可以使用`spring.devtools.restart.exclude`属性。例如，仅仅需要排除掉/static和 /public，你可以设置如下所示的配置：

```properties
spring.devtools.restart.exclude=static/**,public/**
```

> **提示**
>
> 如果你需要在原来忽略资源的基础上添加自己需要忽略的资源，使用`spring.devtools.restart.additional-exclude`属性代替即可

###查看额外的路径

当你想要在修改你应用程序classpath以外的的文件也可以触发自动重启。可以通过配置`spring.devtools.restart.additional-paths`属性来加入监听范围。你可以使用`spring.devtools.restart.exclude`属性来排除前面控制额外路径下的变化是否会触发一个完整的重启或重新加载。

### 禁用重启

如果你不需要使用重启这个特性。你可以使用`spring.devtools.restart.enabled`属性来禁用。大部分情况下，你需要设置这个属性在你的application.properties 配置中（禁用后，依然初始化重启的类加载器，只是不再监听任何文件的变化了）。

如果你需要完全的禁止自动重启的支持（例如，它会与某些特定的library不兼容），你需要在你的系统配置中设置`spring.devtools.restart.enabled`的值为false，它需要在SpringApplication.run(…)运行之前，如下所示：

```java
public static void main(String[] args) {
    System.setProperty("spring.devtools.restart.enabled", "false");
    SpringApplication.run(MyApp.class, args);
}
```

### 使用触发文件

如果你使用IDE，当文件改变的时候它会不断的编译，你会更愿意在特定的时间触发重启。你可以使用“trigger file（触发文件）”来做到，当你想要触发自动重启检查的时候，你就必须要修改特定文件来做到。更改文件只会触发检查，只有当Devtools检测到它必须做某些事时才会启动重启。这个文件必须要手动的更新或者利用IDE插件更新。

使用这个特定文件，设置`spring.devtools.restart.trigger-file`属性指定到这个特定文件的路径即可。

> **提示**
>
> 设置`spring.devtools.restart.trigger-file`为全局设置的时候，你所有的项目都可以应用到这个配置。

### 自定义重启类加载器

如前所述，在重新启动和重新加载部分中，重启功能是通过使用两个类加载器实现的。在大部分的应用程序中，这种方式可以很好的工作。然而，它在某些时候会引起一些类加载器的问题。

默认情况下，您的IDE中的任何开放项目都装载了“(restart)重启”类加载器，并且任何常规的.jar文件都装载了“base(基础)”类加载器。如果你在一个多模块项目中工作,并不是所有模块都会被你的IDE引入的，你需要自定义一些事情。这样子的话，你需要创建一个META-INF/spring-devtools.properties文件。

spring-devtools.properties文件可以包含如restart.exclude 和 restart.include前缀的属性配置。include节点的配置会被“restart（重启）”类加载器拉取到，exclude节点的配置会被“base(基础)”类加载器加载到。属性值是一个会被应用到classpath的正则表达式，如下面的例子所示：

```properties
restart.exclude.companycommonlibs=/mycorp-common-[\\w-]+\.jar
restart.include.projectcommon=/mycorp-myproj-[\\w-]+\.jar
```

> **注意**
>
>所有属性的key都必须是唯一的。例如属性的前缀restart.include. 或者restart.exclude.都是经过深思熟虑设计的。

> **提示**
>
> 所有classpath下的META-INF/spring-devtools.properties文件都是会被加载的。你可以打包进你的项目内，或者在你项目librarie（库）里面也是可以的。

### 已知的限制

在使用ObjectInputStream功能的时候，重启功能对于项目的反序列化支持并不是很好。如果你需要反序列化数据，你也许需要使用spring的`ConfigurableObjectInputStream`结合`Thread.currentThread().getContextClassLoader()`。

不幸的是，一些第三方库在不考虑上下文类加载器的情况下反序列化。如果您发现了这样的问题，您需要向原作者请求修复。

## LiveReload

`spring-boot-devtools`模块包含了一个嵌入式的LiveReload服务，它可以在资源发生改变的时候触发浏览器的刷新事件。LiveReload在 [livereload.com](https://livereload.com/extensions/)中提供了Chrome、Firefox 和Safari 浏览器免费的扩展程序。

当你不希望LiveReload在你程序 运行的时候启动，你可以通过设置属性`spring.devtools.livereload.enabled=false`的方式禁止。

> **注意**
>
> 你只能同时运行一个LiveReload服务。在你启动程序的时候，需要确保没有另外一个LiveReload服务运行。如果你在你的IDE启动多个应用程序，只有第一个LiveReload是被支持的。

## 全局设置

你可以配置一个全局的devtools，在你的$HOME文件夹添加一个文件，文件名为`.spring-boot-devtools.properties`(注意这里的文件名的前缀是“.”)。这个文件里面的所有属性配置，能在你这台机器的所有Spring Boot应用程序生效，当前，是需要使用了devtools的。

~/.spring-boot-devtools.properties.

```properties
spring.devtools.reload.trigger-file=.reloadtrigger
```

## 远程的应该程序

Spring Boot developer工具并不局限于本地开发。在远程运行应用程序时，您还可以使用几个特性。远程支持选择性加入。启动它，您需要确保devtools包含在重新打包的文件中，需要如下所示配置：

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
            	<excludeDevtools>false</excludeDevtools>
            </configuration>
        </plugin>
    </plugins>
</build>
```

然后你需要设置如下 属性：`spring.devtools.remote.secret`，如下所示：

```properties
spring.devtools.remote.secret=mysecret
```

> **警告**
>
> 在远程应用程序中启用spring-boot-devtools存在安全风险。你绝对不能在生产环境开启这个特性。

远程devtools支持分为两部分：一个服务器端端点，它接受连接和您在IDE中运行的客户端应用程序。当`spring.devtools.remote.secret`属性设置时，服务器端组件将自动启用。客户端组件需要手动启动。

### 运行一个远程客户端程序

远程客户端应用程序是被设计成运行在你的IDE的。你需要和你链接的远程项目保持运行相同的`org.springframework.boot.devtools.RemoteSpringApplication`。应用程序的单一必需参数是它连接的远程URL。

例如，如果你有一个应用程序，程序名为`my-app`，运行在你的Eclipse或者STS，你需要部署在Cloud Foundry，具体操作如下：

- 在Run菜单选择Run Configurations…
- 创建一个Java应用程序“launch configuration”
- 浏览“my-app”项目
- 在main函数使用`org.springframework.boot.devtools.RemoteSpringApplication` 
- 添加https://myapp.cfapps.io参数去你的程序（或者你的远程URL）

一个运行的远程客户端可能如下所示：

```java
. ____ _ __ _ _
/\\ / ___'_ __ _ _(_)_ __ __ _ ___ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | | _ \___ _ __ ___| |_ ___ \ \ \ \
\\/ ___)| |_)| | | | | || (_| []::::::[] / -_) ' \/ _ \ _/ -_) ) ) ) )
' |____| .__|_| |_|_| |_\__, | |_|_\___|_|_|_\___/\__\___|/ / / /
=========|_|==============|___/===================================/_/_/_/
:: Spring Boot Remote :: 2.0.3.RELEASE
2015-06-10 18:25:06.632 INFO 14938 --- [ main] o.s.b.devtools.RemoteSpringApplication: Starting RemoteSpringApplication on pwmbp with PID 14938 (/Users/pwebb/projects/spring-boot/code/spring-boot-devtools/target/classes started by pwebb in /Users/pwebb/projects/spring-boot/code/spring-boot-samples/spring-boot-sample-devtools)
2015-06-10 18:25:06.671 INFO 14938 --- [ main] s.c.a.AnnotationConfigApplicationContext: Refreshing org.springframework.context.annotation.AnnotationConfigApplicationContex @2a17b7b6: startupdate [Wed Jun 10 18:25:06 PDT 2015]; root of context hierarchy
2015-06-10 18:25:07.043 WARN 14938 --- [ main] o.s.b.d.r.c.RemoteClientConfiguration : The connection to http://localhost:8080 is insecure. You should use a URL starting with 'https://'.
2015-06-10 18:25:07.074 INFO 14938 --- [ main] o.s.b.d.a.OptionalLiveReloadServer :LiveReload server is running on port 35729
2015-06-10 18:25:07.130 INFO 14938 --- [ main] o.s.b.devtools.RemoteSpringApplication : Started RemoteSpringApplication in 0.74 seconds (JVM running for 1.105)
```

> **注意**
>
> 因为远程客户端使用与真实应用程序相同的类路径，所以它可以直接读取应用程序属性。这就是`spring.devtools.remote.secret`属性被读取并传递给服务器进行身份验证的方式。

> **提示**
>
> 使用https：//作为连接协议是明智的，因为数据都会被加密，不用担心密码等信息会被中途拦截。

> **提示**
>
> 如果你远端程序需要使用代理，需要配置`spring.devtools.remote.proxy.host`和 `spring.devtools.remote.proxy.port`属性

### 远程更新

你程序的classpath发生改变的时候本地重启会被远程客户端监听器监听到。任何的修改都会被推送到远端程序（如果需要）并且触发重启。在你本地没有云服务的情况下，如果您对一个特性进行迭代，这将是很有帮助的。通常，远程更新和重启比完整的重建和部署周期要快得多。

> **注意**
>
> 文件只会在远程客户端启动的时候被监控。如果你在程序启动前修改远程客户端，修改的东西是不会被推送到远程服务端的。

# 打包生产环境的应用程序

可执行jar可以用于生产环境部署。由于它们是独立的，它们也非常适合基于云的部署。

对于额外的“生产就绪”特性，诸如：健康、统计、rest标准或者JMX结束点，可以添加`spring-boot-actuator`

# 延伸阅读

您现在应该了解如何使用Spring Boot和一些您应该遵循的最佳实践。您现在可以深入了解特定的Spring Boot特性，或者你可以跳过前面，阅读Spring Boot的“生产就绪”方面的内容

# Spring Boot特性

本章将深入的介绍Spring Boot特性。在这里，您可以了解您可能想要使用和定制的关键特性。

## SpringApplication

SpringApplication类提供了一种方便的方式来引导从main（）方法启动的Spring应用程序。在很多时候，你可以委托SpringApplication.run静态方法，如下所示：

```java
public static void main(String[] args) {
	SpringApplication.run(MySpringConfiguration.class, args);
}
```

当你的应用程序启动，你可以看到一些类似如下所示的输出：

```java
. ____ _ __ _ _
/\\ / ___'_ __ _ _(_)_ __ __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
\\/ ___)| |_)| | | | | || (_| | ) ) ) )
' |____| .__|_| |_|_| |_\__, | / / / /
=========|_|==============|___/=/_/_/_/
:: Spring Boot :: v2.0.3.RELEASE
2013-07-31 00:08:16.117 INFO 56603 --- [ main] o.s.b.s.app.SampleApplication : Starting SampleApplication v0.1.0 on mycomputer with PID 56603 (/apps/myapp.jar started by pwebb)
2013-07-31 00:08:16.166 INFO 56603 --- [ main]
ationConfigServletWebServerApplicationContext : Refreshing org.springframework.boot.web.servlet.context.AnnotationConfigServletWebServerApplicationContext@6e5a8246:startup date [Wed Jul 31 00:08:16 PDT 2013]; root of context hierarchy
2014-03-04 13:09:54.912 INFO 41370 --- [ main] .t.TomcatServletWebServerFactory :Server
initialized with port: 8080
2014-03-04 13:09:56.501 INFO 41370 --- [ main] o.s.b.s.app.SampleApplication : Started SampleApplication in 2.992 seconds (JVM running for 3.658)
```

