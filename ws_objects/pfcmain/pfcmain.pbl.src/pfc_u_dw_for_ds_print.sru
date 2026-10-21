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
long ll_rowcount, ll_pagecount, ll_lastpagecount, ll_stalled
constant long MAX_STALLED_INSERTS = 1000

this.modify ( 'datawindow.print.preview=yes' )
// The caller normally copies the source via SetFullState, so the page count
// already matches. Only pad with empty rows as a fallback, and stop if the
// inserts fail or stop increasing the page count (e.g. crosstabs).
ll_rowcount = this.rowcount()
ll_lastpagecount = long ( this.describe ("evaluate('pagecount()'," + string ( max ( ll_rowcount, 1 ) ) + ")"))
ll_pagecount = ll_lastpagecount
do while ll_pagecount < al_pages
	// Insert rows until pagecount is the same as source DS.
	// This is needed so the user can set the desired pages in the print dialog.
	if this.insertrow( 0 ) < 1 then exit
	if this.rowcount() <= ll_rowcount then exit
	ll_rowcount = this.rowcount()
	ll_pagecount = long ( this.describe ("evaluate('pagecount()'," + string ( ll_rowcount ) + ")"))
	if ll_pagecount > ll_lastpagecount then
		ll_lastpagecount = ll_pagecount
		ll_stalled = 0
	else
		ll_stalled ++
		if ll_stalled >= MAX_STALLED_INSERTS then exit
	end if
loop
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

