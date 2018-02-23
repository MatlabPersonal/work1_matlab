function RunTime = estimateRunTime(Stc, FootStrike, ToeOff)
RunTime = (Stc(ToeOff)-Stc(FootStrike))/1000;
end