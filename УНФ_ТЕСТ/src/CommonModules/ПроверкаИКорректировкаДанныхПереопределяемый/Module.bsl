#Область ПрограммныйИнтерфейс

// Вызывается при формировании списка доступных пользователю обработок проверки/корректировки, позволяет дополнить
// сформированный список своими обработками.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//   Обработчики - Соответствие - соответствие, где:
//     * Ключ - УникальныйИдентификатор - идентификатор проверки.
//     * Значение - Строка - имя модуля проверки, который содержит следующие экспортные процедуры:
//         ПроверкаИКорректировкаДанных_ЗаполнитьСведения, параметры процедуры:
//              * Сведения - Структура - структура с ключами:
//                   ** Наименование - Строка - наименование проверки.
//                   ** Описание - Строка - описание проверки, необязательное.
//                   ** РазделенныеДанные - Булево - какие данные будут проверяться, в зависимости от этого значения,
//                           в разных режимах будут показаны разные проверки.
//                   ** Настройки - Структура - настройки, которые пользователь может редактировать. Имеет смысл заполнять
//                         если указана форма настроек. Эти настройки будут сохраняться между использованиями.
//                   ** ФормаНастроек - Строка - полное имя формы настроек, необязательное.
//                         В форму настроек передаются следующие параметры:
//                           * Настройки - Строка - адрес во временном хранилище, где хранятся настройки. 
//                           * ВременныеДанные - Строка - адрес во временном хранилище, где хранятся временные данные
//                                 (не сохраняются между использованиями).
//                           * Исправлять - Булево - если Истина, значит требуется исправление данных.
//                         В форме настроек после редактирования все настройки нужно поместить во временное хранилище с
//                         новыми адресами и вернуть структуру с ключами:
//                           * Настройки - Строка - адрес во временном хранилище, где хранятся настройки. 
//                           * ВременныеДанные - Строка - адрес во временном хранилище, где хранятся временные данные.
//         ПроверкаИКорректировкаДанных_ПроверитьНастройки, параметры процедуры:
//              * Настройки - Структура - настройки полученные из процедуры ЗаполнитьСведения.
//              * ВременныеДанные - Структура - временные настройки, полученные из формы настроек.
//              * Исправлять - Булево - Истина, если требуется исправление данных.
//              * Отказ - Булево - если присвоить значение Истина, значит настройки содержат ошибки.
//         ПроверкаИКорректировкаДанных_ПроверитьДанные, параметры процедуры:
//              * Настройки - Структура - настройки полученные из процедуры ЗаполнитьСведения.
//              * ВременныеДанные - Структура - временные настройки, полученные из формы настроек.
//              * Исправлять - Булево - Истина, если требуется исправление данных.
//              * Результат - Структура - структура, значения которой нужно заполнить, ключи:
//                 ** ОбнаруженыПроблемы - Булево - по умолчанию Ложь.
//                 ** ПредставлениеРезультата - Строка - краткое представление результата, 
//                    если ОбнаруженыПроблемы = Истина, то обязательно для заполнения.
//                 ** ТабличныйДокумент - ТабличныйДокумент - подробное представление, необязательное.
//
// Пример:
//   Обработчики.Вставить(Новый УникальныйИдентификатор("2b1043e2-9e00-4518-ac0d-1a2befdcce1x"), 
//   					  "Обработки.ПроверкаИзмеренийВРегистрахБухгалтерии");
//
Процедура ПриЗаполненииПроверок(Обработчики) Экспорт
КонецПроцедуры

#КонецОбласти
