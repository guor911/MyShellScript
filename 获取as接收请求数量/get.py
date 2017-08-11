#/usr/bin/python
import os
import commands


qidlist = ['AAAAAAAA', 'AAAAAAAB','AAAAAAAC','AAAAAAAD','AAAAAAAE','AAAAAAAF','AAAAAAAG','AAAAAAAH','AAAAAAAI',
          'AAAAAAAJ', 'AAAAAABA','AAAAAABB','AAAAAABC','AAAAAABD','AAAAAABE','AAAAAABF','AAAAAABG','AAAAAABH',
          'AAAAAABI', 'AAAAAABJ','AAAAAACA','AAAAAACB','AAAAAACC','AAAAAACD','AAAAAACE','AAAAAACF','AAAAAACG',
          'AAAAAACH', 'AAAAAACI','AAAAAACJ','AAAAAADA','AAAAAADB','AAAAAADC','AAAAAADD','AAAAAADE','AAAAAADF',
          'AAAAAADG', 'AAAAAADH','AAAAAADI','AAAAAADJ','AAAAAAEA','AAAAAAEB','AAAAAAEC','AAAAAAED','AAAAAAEE',
          'AAAAAAEF', 'AAAAAAEG','AAAAAAEH','AAAAAAEI','AAAAAAEJ','AAAAAAFA','AAAAAAFB','AAAAAAFC','AAAAAAFD',
          'AAAAAAFE', 'AAAAAAFF','AAAAAAFG','AAAAAAFH','AAAAAAFI','AAAAAAFJ','AAAAAAGA','AAAAAAGB','AAAAAAGC',
          'AAAAAAGD', 'AAAAAAGE','AAAAAAGF','AAAAAAGG','AAAAAAGH','AAAAAAGI','AAAAAAGJ','AAAAAAHA','AAAAAAHB',
          'AAAAAAHC', 'AAAAAAHD','AAAAAAHE','AAAAAAHF','AAAAAAHG','AAAAAAHH','AAAAAAHI','AAAAAAHJ','AAAAAAIA',
          'AAAAAAIB', 'AAAAAAIC','AAAAAAID','AAAAAAIE','AAAAAAIF','AAAAAAIG','AAAAAAIH','AAAAAAII','AAAAAAIJ',
          'AAAAAAJA', 'AAAAAAJB','AAAAAAJC','AAAAAAJD','AAAAAAJE','AAAAAAJF','AAAAAAJG','AAAAAAJH','AAAAAAJI',
          'AAAAAAJJ']
total_streamctrNo=0
total_streamstopNo=0

if __name__=='__main__':
    for i in qidlist:
	os.environ['qid']=str(i)
	streamctrNo=commands.getoutput("cat AS-RTP-SVR-2017-04-13.log |grep '<streamControl'|grep $qid|wc -l")	
	streamstopNo=commands.getoutput("cat AS-RTP-SVR-2017-04-13.log |grep '<streamStop'|grep $qid|wc -l")
	total_streamctrNo=total_streamctrNo + int(streamctrNo)
	total_streamstopNo=total_streamstopNo + int(streamstopNo)
	print('qid= '+i+' streamctrNo= '+str(streamctrNo) +'  streamstopNo= '+str(streamstopNo))
    print 'total_streamctrNo: ' + str(total_streamctrNo)
    print 'total_streamstopNo: ' + str(total_streamstopNo)
