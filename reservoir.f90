module reservoir
  use mtmod
!$  use omp_lib

  implicit none
  private

  real, public, parameter :: pi=3.141592653589793238463
  real, parameter :: d2r=0.017453292519943295769

  integer, public, parameter :: nparmax=12
  integer :: npars
  integer, public, parameter :: nnodes=1000

  integer, dimension(nnodes) :: nedge
  integer, dimension(nnodes,nnodes) :: iedge

  real, parameter :: delta=0.99

  real, parameter :: winrate=0.1
  real, parameter :: connectrate=0.1

  real, dimension(nnodes,nnodes) :: wmat, wmatsv
  real, dimension(nnodes,nparmax) :: winput
  real, dimension(nnodes) :: gmm
  real, dimension(nnodes) :: bias


  public init_reservoir
  public forward
contains
  subroutine init_reservoir(np,xnds)
    integer, intent(in) :: np 
    real, dimension(nnodes), intent(inout) :: xnds
    integer :: i,j,k
    real :: r

    integer, parameter :: lwork=5*nnodes
    real, dimension(lwork) :: work,rwork
    real, dimension(nnodes) :: svec
    real, dimension(nnodes,nnodes) :: umat,vtmat
    integer :: info
    integer :: nconnect

    nconnect=nint(connectrate*nnodes)
    npars=np

    call sgrnd(11)

    winput(:,:)=0.0
    wmat(:,:)=0.0

    do i=1,nnodes
      xnds(i)=tanh(normalrnd())

      bias(i)=1.0*normalrnd()

      do j=1,npars
        r=grnd()
        if(r < winrate) winput(i,j)=weight_val()

      end do

      k=0

      do j=1,nnodes
        r=grnd()
        if(r < winrate) wmat(i,j)=weight_val()
      end do

    end do

    wmatsv(:,:)=wmat(:,:)

    call dgesvd('A','A',nnodes,nnodes,wmatsv,nnodes,svec,umat,nnodes,&
         vtmat,nnodes,work,lwork,info)

    write(6,*) svec(1)

    do j=1,nnodes
      do i=1,nnodes
        wmat(i,j)=delta*wmat(i,j)/svec(1)
      end do
    end do

    return
  end subroutine init_reservoir


  real function weight_val()
    real :: r
    real, parameter :: wscale=1.0

    r=grnd()

    weight_val=wscale*normalrnd()

    return
  end function weight_val


  subroutine forward(zinput,xnds)
    real, dimension(nparmax) :: zinput
    real, dimension(nnodes) :: xnds
    real, dimension(nnodes) :: xnew
    real :: xs
    integer :: i,j
    real, parameter :: alpha=0.0

    call dgemv('n',nnodes,npars,1.0,winput,nnodes,zinput,1,0.0,xnew,1)
    call dgemv('n',nnodes,nnodes,1.0,wmat,nnodes,xnds,1,1.0,xnew,1)

!$omp parallel do
    do i=1,nnodes
      xnds(i)=alpha*xnds(i)+(1.0-alpha)*tanh(xnew(i)+bias(i))
    end do
!$omp end parallel do

  end subroutine forward

  real(8) function normalrnd()
    real(8) :: a, b
!    real(8), parameter :: pi=3.141592653589793238463

    a=(1.0d0-grnd())
    b=(1.0d0-grnd())

    normalrnd=sqrt(-2.0d0*log(a))*sin(2.0d0*pi*b)

    return
  end function normalrnd
end module reservoir
