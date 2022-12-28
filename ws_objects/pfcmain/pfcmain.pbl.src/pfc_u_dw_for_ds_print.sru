$PBExportHeader$pfc_u_dw_for_ds_print.sru
forward
global type pfc_u_dw_for_ds_print from u_dw
end type
end forward

global type pfc_u_dw_for_ds_print from u_dw
end type
global pfc_u_dw_for_ds_print pfc_u_dw_for_ds_print

type variables
private:
	boolean ib_usercancelled = true

end variables

forward prototypes
public function integer of_printsetup (readonly long al_pages)
end prototypes

public function integer of_printsetup (readonly long al_pages);/////////////////////////////////////////////////////////////////////////
//
// Display print dialog to set print specs needed for Datastore printing
//
/////////////////////////////////////////////////////////////////////////
integer li_rc
this.modify ( 'datawindow.print.preview=yes' )
do
	// Insert rows until pagecount is the same as source DS. 
	// This is needed so the user can set the desired pages in the print dialog.
	this.insertrow( 0 )
  // I have not encountered an issue with this so far but There may be
  // a need for  safeguarding against a potential infinite loop here.
  // To be safe, maybe add a counter variable and exit the loop
  // when an implausibly high loop count is hit.
loop while long ( this.describe ("evaluate('pagecount()'," + string ( this.rowcount() ) + ")")) < al_pages
this.modify ( 'datawindow.print.preview=no' )

// We only want the print dialog to set all the specs to the DW so printing is cancelled
// immediately in printstart(). Therefore print() itself will *always* return -1 here.
// In order to still correctly identify the user pressing "Cancel" during the print dialog, this flag is set to true.
// If it wasn't reset to false in printstart(), we know that the dialog was cancelled by the user.
ib_usercancelled = true
this.print( true, true )
if not ib_usercancelled then
  // continue printing the DS
	li_rc = 1
else
  // dialog was cancelled by user, return -1 accordingly
	li_rc = -1
end if
// reset flag to default
ib_usercancelled = true
return li_rc

end function

on pfc_u_dw_for_ds_print.create
call super::create
end on

on pfc_u_dw_for_ds_print.destroy
call super::destroy
end on

event printstart;call super::printstart;/////////////////////////////////////////////////////////////////////////
//
// Cancel print immediately.
// At this point the print dialog was OK'd so set ib_usercancelled to false
// 
/////////////////////////////////////////////////////////////////////////
ib_usercancelled = false
this.printcancel( )

end event

