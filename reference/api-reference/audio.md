# 📻 Audio

Audio

## Get audio for the current position

<mark style="color:blue;">`GET`</mark> `https://api.filmprojekt1.de/api/audio?`

#### Request Body

| Name                                            | Type   | Description            |
| ----------------------------------------------- | ------ | ---------------------- |
| userLatitude<mark style="color:red;">\*</mark>  | string | Latitude of the user   |
| userLongitude<mark style="color:red;">\*</mark> | string | Longitude  of the user |

{% tabs %}
{% tab title="200 Pet successfully created" %}
{% code fullWidth="true" %}
```javascript
{
    "audioFiles": [
        {
            "id": 1,
            "latitude": 51.65031505010827,
            "longitude": 7.335165253996581,
            "audio_url": "https://nabeba.filmprojekt1.de/schule/mp3_tream.mp3"
        }
    ]
}
```
{% endcode %}
{% endtab %}

{% tab title="401 Permission denied" %}

{% endtab %}
{% endtabs %}
