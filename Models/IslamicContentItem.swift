//
//  IslamicContentItem.swift
//  Seemi's Spiritual Companion
//
//  Data model for Islamic content
//

import Foundation

struct IslamicContentItem: Identifiable {
    let id = UUID()
    let title: String
    let arabicText: String
    let englishTranslation: String
    let source: String
    let audioURL: String? // For Phase 3
    let repeatCount: Int
    let hasAudio: Bool // True if authentic audio available
    
    // MARK: - The Exact 8 Items
    static let allItems: [IslamicContentItem] = [
        // 1. Dua to Remove Worry/Sorrow
        IslamicContentItem(
            title: "Dua to Remove Worry & Sorrow",
            arabicText: "اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِي كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِي عِلْمِ الْغَيْبِ عِنْدَكَ، أَنْ تَجْعَلَ الْقُرْآنَ رَبِيعَ قَلْبِي، وَنُورَ صَدْرِي، وَجَلَاءَ حُزْنِي، وَذَهَابَ هَمِّي",
            englishTranslation: "O Allah, I am Your servant, son of Your servant, son of Your maidservant. My forelock is in Your hand, Your command over me is forever executed and Your decree over me is just. I ask You by every name belonging to You which You have named Yourself with, or revealed in Your Book, or You taught to any of Your creation, or You have preserved in the knowledge of the Unseen with You, that You make the Quran the life of my heart and the light of my breast, and a departure for my sorrow and a release for my anxiety.",
            source: "Musnad Ahmad 1/391",
            audioURL: "https://youtu.be/XBuS7NTxz5A", // YouTube link - opens in browser
            repeatCount: 1,
            hasAudio: true // YouTube: Authentic Dua recitation
        ),
        
        // 2. Morning/Evening Dua (Protection)
        IslamicContentItem(
            title: "Morning & Evening Protection Dua",
            arabicText: "بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            englishTranslation: "In the Name of Allah, Who with His Name nothing can cause harm in the earth nor in the heavens, and He is the All-Hearing, the All-Knowing.",
            source: "Abu Dawud 5088, At-Tirmidhi 3388",
            audioURL: "https://youtu.be/XBuS7NTxz5A", // YouTube link - opens in browser
            repeatCount: 3,
            hasAudio: true // YouTube: Morning & Evening Protection Dua (recite 3x)
        ),
        
        // 3. Surah Ar-Rahman
        IslamicContentItem(
            title: "Surah Ar-Rahman (The Most Merciful)",
            arabicText: "الرَّحْمَٰنُ عَلَّمَ الْقُرْآنَ خَلَقَ الْإِنسَانَ عَلَّمَهُ الْبَيَانَ... [Full 78 verses - tap play for complete audio recitation]",
            englishTranslation: "The Most Merciful. Taught the Quran. Created man. [He] taught him eloquence... [Full surah with beautiful recitation available]",
            source: "Quran 55:1-78",
            audioURL: "surah_ar_rahman_mishary", // Bundled audio - Sheikh Mishary from SoundCloud
            repeatCount: 1,
            hasAudio: true // Full Surah Ar-Rahman - plays in app offline!
        ),
        
        // 4. Dua for Tension/Depression (Tawakkul)
        IslamicContentItem(
            title: "Dua for Tension & Depression",
            arabicText: "وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ",
            englishTranslation: "And whoever relies upon Allah - then He is sufficient for him.",
            source: "Quran 65:3 (At-Talaq)",
            audioURL: "https://youtu.be/XBuS7NTxz5A", // YouTube link - opens in browser
            repeatCount: 1,
            hasAudio: true // YouTube: Tension/Depression Dua
        ),
        
        // 5. Wazifa for Protection (same as #2)
        IslamicContentItem(
            title: "Wazifa for Protection",
            arabicText: "بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            englishTranslation: "In the Name of Allah, Who with His Name nothing can cause harm in the earth nor in the heavens, and He is the All-Hearing, the All-Knowing.",
            source: "Abu Dawud 5088",
            audioURL: "https://youtu.be/XBuS7NTxz5A", // YouTube link - same as #2
            repeatCount: 3,
            hasAudio: true // YouTube: Protection Wazifa (recite 3x)
        ),
        
        // 6. Dua for Healing
        IslamicContentItem(
            title: "Dua for Healing",
            arabicText: "وَنُنَزِّلُ مِنَ الْقُرْآنِ مَا هُوَ شِفَاءٌ وَرَحْمَةٌ لِّلْمُؤْمِنِينَ",
            englishTranslation: "And We send down of the Quran that which is healing and mercy for the believers.",
            source: "Quran 17:82 (Al-Isra)",
            audioURL: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/017.mp3",
            repeatCount: 1,
            hasAudio: true // Full Surah Al-Isra (healing verse) - streams from Quran.com
        ),
        
        // 7. Dua Al-Hasad (Protection from Evil Eye)
        IslamicContentItem(
            title: "Dua Against Evil Eye (Al-Hasad)",
            arabicText: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ مِن شَرِّ مَا خَلَقَ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ",
            englishTranslation: "Say: I seek refuge with the Lord of the daybreak, from the evil of what He has created, and from the evil of darkness when it settles, and from the evil of the blowers in knots, and from the evil of an envier when he envies.",
            source: "Quran 113 (Al-Falaq)",
            audioURL: "https://download.quranicaudio.com/quran/mishaari_raashid_al_3afaasee/113.mp3", // Surah Al-Falaq
            repeatCount: 1,
            hasAudio: true // Perfect! Surah Al-Falaq (113) - streams from Quran.com
        ),
        
        // 8. Manzil Dua (33 Ayahs Summary)
        IslamicContentItem(
            title: "Manzil Dua (Protection Collection)",
            arabicText: "مَنزِل - 33 آيات من القرآن الكريم: الفاتحة، البقرة (1-5، 163، 255-257، 284-286)، آل عمران (18-19، 26-27)، الأعراف (54-56)، الإسراء (110-111)، المؤمنون (115-118)، الصافات (1-11)، الرحمن (33-40)، الحشر (21-24)، الجن (1-4)، الكافرون، الإخلاص، الفلق، الناس",
            englishTranslation: "Manzil is a collection of 33 verses from the Quran: Al-Fatiha, Al-Baqarah (1-5, 163, 255-257, 284-286), Al-Imran (18-19, 26-27), Al-A'raf (54-56), Al-Isra (110-111), Al-Mu'minun (115-118), As-Saffat (1-11), Ar-Rahman (33-40), Al-Hashr (21-24), Al-Jinn (1-4), Al-Kafirun, Al-Ikhlas, Al-Falaq, An-Nas. [Full text - read from Quran]",
            source: "Compiled from Quran",
            audioURL: "manzil_dua_fast", // Bundled audio from SoundCloud (16 MB)
            repeatCount: 1,
            hasAudio: true // Complete Manzil Dua (fast cure & protection) - plays in app offline!
        )
    ]
}
