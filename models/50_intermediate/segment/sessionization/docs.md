---
title: Sessionization Docs
render_with_liquid: false
---

### segment_web_user_stitching


### segment_web_page_views__sessionized

{% docs segment_web_page_views__sessionized %}

The purpose of this model is to assign a `session_id` to page views. The business logic of how this is done is that any period of inactivity of 30 minutes or more resets the session, and any subsequent page views are assigned a new `session_id`.

The implementation of this logic is rather involved, and requires multiple CTEs. Comments have been added to the source to describe the purpose of the CTEs that are more esoteric.

{% enddocs %}


### segment_web_sessions__initial

{% docs segment_web_sessions__initial %}

This model performs the aggregation of page views into sessions. The `session_id` having already been calculated in `segment_web_page_views__sessionized`, this model simply calls a bunch of window functions to grab the first or last value of a given field and store it at the session level.

{% enddocs %}


### segment_web_sessions__stitched


### segment_web_sessions

{% docs segment_web_sessions %}

The purpose of this model is to expose a single web session, derived from Segment web events. Sessions are the most common way that analysis of web visitor behavior is conducted, and although Segment doesn't natively output session data, this model uses standard logic to create sessions out of page view events.

A session is meant to represent a single instance of web activity where a user is actively browsing a website. In this case, we are demarcating sessions by 30 minute windows of inactivity: if there is 30 minutes of inactivity between two page views, the second page view begins a new session. Additionally, page views across different devices will always be tied to different sessions.

The logic implemented in this particular model is responsible for incrementally calculating a user's session number; the core sessionization logic is done in upstream models.

{% enddocs %}
