//
//  QuizBank.swift
//  TestAppN1
//
//  Created by AI Assistant.
//

import Foundation

enum QuizBank {
    static func questions(category: QuizCategory, difficulty: QuizDifficulty) -> [QuizQuestion] {
        let base: [QuizQuestion] = [
            QuizQuestion(
                prompt: "Кто автор 'Преступление и наказание'?",
                options: ["Фёдор Достоевский", "Лев Толстой", "Иван Тургенев", "Антон Чехов"],
                correctIndex: 0,
                category: .authors,
                difficulty: .easy
            ),
            QuizQuestion(
                prompt: "Какой роман написал Джордж Оруэлл?",
                options: ["451° по Фаренгейту", "О дивный новый мир", "1984", "Мы"],
                correctIndex: 2,
                category: .books,
                difficulty: .easy
            ),
            QuizQuestion(
                prompt: "Чья это цитата: 'Быть или не быть'?",
                options: ["Уильям Шекспир", "Джейн Остин", "Чарльз Диккенс", "Оскар Уайльд"],
                correctIndex: 0,
                category: .quotes,
                difficulty: .easy
            ),
            QuizQuestion(
                prompt: "Кто написал 'Мастер и Маргарита'?",
                options: ["Михаил Булгаков", "Александр Солженицын", "Борис Пастернак", "Илья Ильф"],
                correctIndex: 0,
                category: .authors,
                difficulty: .easy
            ),
            QuizQuestion(
                prompt: "Какое из произведений принадлежит Льву Толстому?",
                options: ["Война и мир", "Братья Карамазовы", "Доктор Живаго", "Мёртвые души"],
                correctIndex: 0,
                category: .books,
                difficulty: .easy
            ),
            QuizQuestion(
                prompt: "Кому приписывают: 'Чтение — вот лучшее учение'?",
                options: ["А. Пушкин", "Л. Толстой", "Н. Гоголь", "И. Тургенев"],
                correctIndex: 3,
                category: .quotes,
                difficulty: .easy
            ),
            QuizQuestion(
                prompt: "К какому веку относят творчество Данте?",
                options: ["XII", "XIII–XIV", "XV", "XVI"],
                correctIndex: 1,
                category: .authors,
                difficulty: .medium
            ),
            QuizQuestion(
                prompt: "Какое произведение открыло жанр антиутопии в XX веке?",
                options: ["Мы", "1984", "Скотный двор", "О дивный новый мир"],
                correctIndex: 0,
                category: .books,
                difficulty: .medium
            ),
            QuizQuestion(
                prompt: "Чья это цитата: 'Все счастливые семьи похожи друг на друга…'?",
                options: ["Лев Толстой", "Иван Тургенев", "Николай Гоголь", "Александр Пушкин"],
                correctIndex: 0,
                category: .quotes,
                difficulty: .medium
            ),
            QuizQuestion(
                prompt: "Кто является автором 'Сто лет одиночества'?",
                options: ["Габриэль Гарсиа Маркес", "Марио Варгас Льоса", "Хулио Кортасар", "Борхес"],
                correctIndex: 0,
                category: .authors,
                difficulty: .medium
            ),
            QuizQuestion(
                prompt: "Какой роман НЕ написал Достоевский?",
                options: ["Идиот", "Бесы", "Отцы и дети", "Игрок"],
                correctIndex: 2,
                category: .books,
                difficulty: .medium
            ),
            QuizQuestion(
                prompt: "'Мы — это мы, а не кто-нибудь другой' — чья мысль?",
                options: ["Замятин", "Хаксли", "Оруэлл", "Брэдбери"],
                correctIndex: 0,
                category: .quotes,
                difficulty: .medium
            ),
            QuizQuestion(
                prompt: "Под каким псевдонимом писал Сэмюэл Клеменс?",
                options: ["О. Генри", "Марк Твен", "Джек Лондон", "Эдгар По"],
                correctIndex: 1,
                category: .authors,
                difficulty: .hard
            ),
            QuizQuestion(
                prompt: "Какое произведение начинается с 'Зов крови…'?",
                options: ["Белый клык", "Мартин Иден", "Сердца трёх", "Морской волк"],
                correctIndex: 0,
                category: .books,
                difficulty: .hard
            ),
            QuizQuestion(
                prompt: "Кому принадлежит: 'Ад — это другие'?",
                options: ["Сартр", "Камю", "Ницше", "Кьеркегор"],
                correctIndex: 0,
                category: .quotes,
                difficulty: .hard
            )
            ,
            QuizQuestion(
                prompt: "Кто автор 'Посторонний'?",
                options: ["Альбер Камю", "Ж.-П. Сартр", "М. Пруст", "А. Жид"],
                correctIndex: 0,
                category: .authors,
                difficulty: .hard
            ),
            QuizQuestion(
                prompt: "Какой роман принадлежит Майн Риду?",
                options: ["Всадник без головы", "Последний из могикан", "Остров сокровищ", "Робинзон Крузо"],
                correctIndex: 0,
                category: .books,
                difficulty: .hard
            ),
            QuizQuestion(
                prompt: "'Счастлив тот, кто счастлив у себя дома' — кто сказал?",
                options: ["Л. Толстой", "А. Чехов", "И. Бунин", "Ф. Достоевский"],
                correctIndex: 1,
                category: .quotes,
                difficulty: .hard
            )
        ]

        switch category {
        case .mixed:
            return base.filter { $0.difficulty == difficulty }
        default:
            return base.filter { $0.category == category && $0.difficulty == difficulty }
        }
    }
}


