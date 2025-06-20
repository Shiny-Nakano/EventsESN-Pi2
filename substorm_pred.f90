program aeana
  use readdata
  use reservoir

  integer, parameter :: nlearn=1051776
  integer, parameter :: niter=20
  integer, parameter :: mininterval=5

  integer, parameter :: nparams=10
  integer, parameter :: nspinup=72

  real, parameter :: deltat=5.0

  integer :: nvalid=0
  integer, parameter :: nhist=12
  integer, parameter :: nhistref=1

  real :: r, rexp
  integer, dimension(nhist) :: iearr
  integer :: iesum
  integer, parameter :: iecri=6

  integer :: nls

  real, parameter :: crit=0.5
  integer, parameter :: ntrain=1051776
  real :: pexpect

  real :: al,au
  real, dimension(nnodes) :: xnodes,xninit,xdnodes
  real, dimension(nparmax,nhist) :: zarrhist
  real, dimension(nparmax) :: zarr
  real, dimension(nnodes,nnodes) :: xhess, xhessinv

  integer :: i,j,k,kk
  real :: check
  real :: alpred, aupred
  real :: pd,xnsw,vsw,tsw,bx,by,bz,alobs,auobs,sym
  integer :: iday
  real :: hour

  real, dimension(nnodes) :: sarr
  real, dimension(nnodes) :: warr, wmin
  real, parameter :: elim=1.0e-6

  integer :: iopt
  real, parameter :: rsig2=1.0e-8
  character(3) :: optch
  character(4) :: yeararr
  character(6) :: skipdir
  character(20) :: intenfile
  character(16) :: alfile
!  character(17) :: ssfile
  character(15) :: wpfile
  integer :: irefyear

  integer, parameter :: ndiv=10
  integer, dimension(ndiv) :: ncountmap
  integer, dimension(ndiv) :: ntotalmap

  davgmin=1.0e8

  call get_command_argument(1,yeararr)
  read(yeararr,*,iostat=ios) irefyear

  ncountmap(:)=0
  ntotalmap(:)=0

  zarr(:)=0.0
  zarrhist(:,:)=0.0
  iearr(:)=1
  check=0.0

  ! open(75,file=trim(wpdir)//'/substorms_cpr.dat')
  ! nevents=0
  ! ios=0
  ! do while(ios==0)
  !   read(75,*,iostat=ios)
  !   nevents=nevents+1
  ! end do
  ! close(75)

  ! pexpect=1.0-exp(-12.0*(nevents-1.0)/ntrain)
  ! write(6,*) nevents-1, pexpect


  open(55,file='wsv_ss.dat')
  do i=1,nnodes
    read(55,*) dum,warr(i)
  end do
  close(55)

  call init_reservoir(nparams,xninit)

220 format(2i4,2i3)

  kk=0
  kcount=0
  wsum=0.0
  ii=0

  xnodes(:)=xninit(:)
  xdnodes(:)=0.0
  xhess(:,:)=0.0
  xhessinv(:,:)=0.0
  xll=0.0

  write(alfile,'("alswdata",i4.4,".dat")') irefyear
  call openfile(alfile)

  write(intenfile,'("intensity",i4.4,".dat")') irefyear

  open(36,file=intenfile)

  kevent=0
  brier=0.0
  brierdum=0.0
  nbrier=0
  ntp=0
  nfp=0
  ntn=0
  nfn=0

  do k=1,nlearn
    kk=kk+1

    ii=ii+1
    call getrec(zarr,ierr,iyear,iday,ihour,imin)
    if(ierr < 0) exit

    do j=nhist,2,-1
      iearr(j)=iearr(j-1)
    end do
    iearr(1)=ierr

    nv=0
    ivalid=nv

    ! ievent=0
    ! do while(iyear==iyev.and.iday==idoyev.and.ihour==ihourev.and.imin==iminev)
    !   ievent=ievent+1
    !   read(25,220,iostat=ios) iyev,idoyev,ihourev,iminev
    !   if(ios/=0) then
    !     iyev=0
    !     idoyev=0
    !     ihourev=0
    !     iminev=0
    !   end if
    !   iminev=iminev/5
    !   iminev=5*iminev
    ! end do

    call forward(zarr,xnodes)

    iesum=sum(iearr)
    if(iesum > iecri) then
      kk=0
    end if

    xintensity = 999.99999

    if(kk > nspinup.and.ivalid==nvalid) then
      wxprod=ddot(nnodes,warr,1,xnodes,1)
      xintensity=exp(wxprod)
    end if

    write(36,'(2i4,2i3,2f12.5)') iyear,iday,ihour,imin,xintensity,1.0-exp(-5.0*xintensity)
  end do

  close(36)
  call closefile

  stop
end program aeana
