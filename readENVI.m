clc;clear;
[D3a,info3a]=enviread('test');
%enviwrite(D3a,'test1');
enviwrite(D3a, 'test1', info3a);