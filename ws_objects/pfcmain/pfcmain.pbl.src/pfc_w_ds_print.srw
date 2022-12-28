$PBExportHeader$pfc_w_ds_print.srw
forward
global type pfc_w_ds_print from w_master
end type
end forward

global type pfc_w_ds_print from w_master
boolean visible = false
integer width = 690
integer height = 568
end type
global pfc_w_ds_print pfc_w_ds_print

on pfc_w_ds_print.create
call super::create
end on

on pfc_w_ds_print.destroy
call super::destroy
end on

