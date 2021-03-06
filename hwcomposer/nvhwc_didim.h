/*
 * Copyright (C) 2010-2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
 */

#ifndef _NVHWC_DIDIM_H
#define _NVHWC_DIDIM_H

#include <hardware/hwcomposer.h>

struct didim_client {
    void (*set_window)(struct didim_client *client, hwc_rect_t *rect);
};

struct didim_client *didim_open(void);
void didim_close(struct didim_client *client);

#endif /* ifndef _NVHWC_DIDIM_H */
