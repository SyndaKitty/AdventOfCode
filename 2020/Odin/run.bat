@SET FOO=%1
@IF 1%Foo% LSS 100 SET Foo=0%Foo%
odin run day%FOO%.odin