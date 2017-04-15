use livesplit_core::SharedTimer;
use timer_read_lock::OwnedTimerReadLock;
use timer_write_lock::OwnedTimerWriteLock;
use super::{alloc, acc, own_drop};

pub type OwnedSharedTimer = *mut SharedTimer;

#[no_mangle]
pub unsafe extern "C" fn SharedTimer_share(this: *const SharedTimer) -> OwnedSharedTimer {
    alloc(acc(this).clone())
}

#[no_mangle]
pub unsafe extern "C" fn SharedTimer_drop(this: OwnedSharedTimer) {
    own_drop(this);
}

#[no_mangle]
pub unsafe extern "C" fn SharedTimer_read(this: *const SharedTimer) -> OwnedTimerReadLock {
    alloc(acc(this).read())
}

#[no_mangle]
pub unsafe extern "C" fn SharedTimer_write(this: *const SharedTimer) -> OwnedTimerWriteLock {
    alloc(acc(this).write())
}
