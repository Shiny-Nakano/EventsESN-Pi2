module readdata
  use reservoir
  implicit none

  integer, parameter :: inputid=15

  public openfile
  public readline
  public closefile
contains
  subroutine openfile(infile)
    character(*) :: infile
    open(inputid,file=infile,status='old')
    return
  end subroutine openfile


  subroutine readline(iy,id,hh,mm,pd,xnsw,vsw,tsw,bx,by,bz,ierr)
    integer, intent(inout) :: iy,id
    integer, intent(inout) :: hh,mm
    real, intent(inout) :: pd,xnsw,vsw,tsw,bx,by,bz
    integer, intent(inout) :: ierr
    integer :: ih,imin
    real :: pbuf,xnbuf,vbuf,tsbuf,bxbuf,bybuf,bzbuf
    integer :: iyy,idoy
    real :: hs,sml,smu

    ierr=0

    read(inputid,250,iostat=ierr) iy,id,ih,imin,pbuf,xnbuf,vbuf,tsbuf,&
         bxbuf,bybuf,bzbuf
250 format(2i4,2i3,3f9.2,f12.1,3f8.2)

    if(ierr /= 0) ierr=-10

    hh=ih
    mm=imin

    if( pbuf < 9000.0 ) then
      pd = pbuf
    else
      ierr = 1
    end if

    if( xnbuf < 9000.0 ) then
      xnsw = xnbuf
    else
      ierr = 1
    end if

    if( vbuf < 9000.0 ) then
      vsw = vbuf
    else
      ierr = 1
    end if

    if( tsbuf < 90000000.0 ) then
      tsw = tsbuf
    else
      ierr = 1
    end if

    if( bxbuf < 900.0 ) then
      bx = bxbuf
    else
      ierr = 1
    end if

    if( bybuf < 900.0 ) then
      by = bybuf
    else
      ierr = 1
    end if

    if( bzbuf < 900.0 ) then
      bz = bzbuf
    else
      ierr = 1
    end if

    return
  end subroutine readline


  subroutine getrec(zrec,ierror,iyear,idoy,ih,imin)
    real, dimension(nparmax), intent(inout) :: zrec
    integer, intent(inout) :: ierror
    real :: alval,auval
    integer :: iyear,idoy,idd
    integer :: ih,imin
    real :: hh
    integer :: i,j
    real :: theta, babs
    real :: phid

    real :: alpred, aupred
    real :: pd,xnsw,vsw,tsw,bx,by,bz


    call readline(iyear,idoy,ih,imin,pd,xnsw,vsw,tsw,bx,by,bz,ierror)

    idd=365*(iyear-2001)+int((iyear-1981)/4)-5+idoy
    hh=ih+imin/60.0
    phid=idd+hh/24.0

    zrec(1)=cos(pi*hh/12.0)
    zrec(2)=sin(pi*hh/12.0)
    zrec(3)=cos(2*pi*phid/365.24)
    zrec(4)=sin(2*pi*phid/365.24)

    if(ierror == 0) then
      zrec(5)=bz/10.0
      zrec(6)=by/10.0
      zrec(7)=bx/10.0

      zrec(8)=(sqrt(vsw)-sqrt(400.0))/10.0
      zrec(9)=log10(xnsw)-log10(2.0)
      zrec(10)=(tsw-2.0e5)/1.0e6
    end if

    return
  end subroutine getrec


  subroutine closefile
    close(inputid)
    return
  end subroutine closefile

end module readdata
