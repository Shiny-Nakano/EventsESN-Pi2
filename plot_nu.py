#!/usr/bin/env python3

import numpy as np
import sys
import matplotlib.pylab as plt

year = int(sys.argv[1])
mon = int(sys.argv[2])
iday = int(sys.argv[3])

ndarr = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
monname = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
nlday = 12 * 24

if year % 4 == 0:
  ndarr[1] = 29

startyear = 1998

nlyear = 0
if year > startyear:
  yy = startyear
  while yy < year:
    if yy % 4 == 0:
      nlyear += 366 * nlday
    else:
      nlyear += 365 * nlday
    yy += 1

aintensity = np.loadtxt("intensity{0:0>4}.dat".format(year))
aintensity[aintensity[:,4] > 900.0,4] = np.nan


swd = np.loadtxt("swdata{0:0>4}.dat".format(year))
for i in range(4,7):
  swd[swd[:,i] > 9000.0,i] = np.nan
swd[swd[:,7] > 900000.0,7] = np.nan
for i in range(8,11):
  swd[swd[:,i] > 900.0,i] = np.nan

nday = 3

md1 = iday - 1
for i in range(mon-1):
  md1 += ndarr[i]

md2 = md1 + nday

i1 = md1 * nlday
i2 = md2 * nlday

aiselect = aintensity[i1:i2,:]

xday = iday + (np.arange(len(aiselect[:,0])) / (1.0*nlday))

aselect = swd[i1:i2,:]

xcolor = "darkgreen"
ycolor = "blue"
zcolor = "red"
vcolor = "magenta"
alval = 1.0
lwval = 0.9

plt.figure( figsize = (12.0, 9.0) )

axoc = plt.subplot(411)
axoc.plot( xday, 60*aiselect[:,4], color=zcolor, lw=1.0, alpha=alval )
axoc.set_xticks(np.arange(iday, iday + nday + 0.1))
axoc.set_xticks(np.arange(iday, iday + nday + 0.1, 0.25), minor=True)
axoc.set_title("{0:2} - {1:2} {2:2} {3:4}".format(iday, iday + nday - 1, monname[mon-1], year) )
axoc.set_xlim([iday, iday + nday])
axoc.set_ylim([0, 4.0])
axoc.set_ylabel("Occurrence rate (/h)")
axoc.grid(which='both')


aximf = plt.subplot(412)
aximf.plot( xday, aselect[:,8], color=xcolor, label="Bx", lw=lwval, alpha=alval )
aximf.plot( xday, aselect[:,9], color=ycolor, label="By", lw=lwval, alpha=alval )
aximf.plot( xday, aselect[:,10], color=zcolor, label="Bz", lw=lwval, alpha=alval )
aximf.set_xlim([iday, iday + nday])
aximf.set_xticks(np.arange(iday, iday + nday + 0.1))
aximf.set_xticks(np.arange(iday, iday + nday + 0.1, 0.25), minor=True)
aximf.set_ylim([-30, 30])
aximf.set_yticks(np.arange(-30, 31, 10))
aximf.set_ylabel("IMF (nT)")
aximf.grid(which='both')
aximf.legend( bbox_to_anchor=(1.01, 1), loc='upper left' )

axv = plt.subplot(413)
axv.plot( xday, aselect[:,6], color=zcolor, lw=lwval, alpha=alval )
axv.set_xlim([iday, iday + nday])
axv.set_xticks(np.arange(iday, iday + nday + 0.1))
axv.set_xticks(np.arange(iday, iday + nday + 0.1, 0.25), minor=True)
axv.set_ylim([250, 900])
axv.set_yticks(np.arange(400, 810, 200))
axv.set_ylabel("Vsw (km/s)")
axv.grid(which='both')

axn = plt.subplot(414)
axn.plot( xday, aselect[:,5], color=zcolor, lw=lwval, alpha=alval )
axn.set_xticks(np.arange(iday, iday + nday + 0.1))
axn.set_xticks(np.arange(iday, iday + nday + 0.1, 0.25), minor=True)
axn.set_xlabel("Day")
axn.set_xlim([iday, iday + nday])
axn.set_ylim([0, 70])
axn.set_ylabel("Nsw (/cc)")
axn.grid(which='both')

plt.subplots_adjust(0.08, 0.06, 0.88, 0.95)

plt.savefig( "Nu{0:0>4}{1:0>2}{2:0>2}.eps".format(year, mon, iday) )
plt.savefig( "Nu{0:0>4}{1:0>2}{2:0>2}.png".format(year, mon, iday) )
plt.close()
