1. 启动jekyll服务 jekyll serve(s)   [帮助手册 jekyll help]
2. 生成新的_post文章 ：rake post title="hello world" date="2016-05-10" (date 是可选参数)
   生成新的_draft文章：rake rake title="hello world"

3. 在文章中按正文标题生成文章目录(详见:2016-05-20-regular-expression.md)
* _config.yml 中配置markdown: kramdown
* 在文章中标识toc的生成位置
    `*目录
    {:toc #标题id}`
    如果某一标题不想加在目录中，在标题下一行{:.no_toc}
