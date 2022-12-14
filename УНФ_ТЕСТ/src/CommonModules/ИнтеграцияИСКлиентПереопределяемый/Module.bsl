#Область СлужебныйПрограммныйИнтерфейс

#Область СерииНоменклатуры

// Процедура обновляет кеш ключевых реквизитов текущей строки товаров. По ключевым реквизитам осуществляется связь
//  между ТЧ серий и ТЧ товаров.
//
// Параметры:
// 
//  ТаблицаФормы - ТаблицаФормы - таблица, в которой отображается ТЧ с товарами.
//  КэшированныеЗначения - Структура - переменная модуля формы, в которой хранятся кешируемые значения.
//  ПараметрыУказанияСерий - ФормаКлиентскогоПриложения, Структура - 
//     управляемая форма содержащая структуру или непосредственно структура параметров указания серий.
//  Копирование - Булево - признак, что кешированная строка скопирована (параметр события ПриНачалеРедактирования).
Процедура ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий = "", Копирование = Ложь) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Процедура проверяет необходимость обновления статусов указания серий при окончании редактирования строки товаров.
//
// Параметры:
//  Обновить - Булево - (исходящий) - необходимость обновления статусов указания серий;
//  Форма   - ФормаКлиентскогоПриложения - форма-источник вызова;
//  Элемент - ТаблицаФормы	 - таблица формы, отображающая ТЧ товаров;
//  КэшированныеЗначения - Структура   - переменная модуля формы, в которой хранятся кешируемые значения;
//  ПараметрыУказанияСерий - Структура - параметры указания серий, возвращаемые соответствующей процедурой
//                                       модуля менеджера документа;
//  Удаление - Булево, Истина - признак, что проверка вызывается при удалении строки ТЧ.
//
Процедура УстановитьОбновитьСтатусыСерий(Обновить, Форма, Элемент, КэшированныеЗначения, ПараметрыУказанияСерий = "", Удаление) Экспорт
	
	Обновить = Ложь;
	
КонецПроцедуры

// Процедура проверяет необходимость указания серий в строке, если возможно, открывает форму указания,
//  если форма указания не требует контекстного вызова сервера.
//
// Параметры:
//  Нужен                  - Булево              - (исходящий) признак необходимости контекстного вызова сервера;
//  Форма                  - ФормаКлиентскогоПриложения    - форма документа, в которой инициировано указание серий;
//  ПараметрыУказанияСерий - Произвольный        - параметры указания серий строки;
//  Текст                  - Строка              - текст, введенный в поле ввода (параметр событий ОкончаниеВводаТекста 
//                                                 и АвтоПодборВводаТекста).
//  ТекущиеДанные          - Структура, ДанныеФормыЭлементКоллекции - данные строки, в которой указывается серия,
//                         - Неопределено        - текущие данные табличного поля с именем ПараметрыУказанияСерий.ИмяТЧТовары;
//  СтандартнаяОбработка   - Булево              - открытие формы выбора серий по умолчанию.
//
Процедура ЗаполнитьДляУказанияСерийНуженСерверныйВызов(
	Нужен, Форма, ПараметрыУказанияСерий, Текст, ТекущиеДанные, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Нужен = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ПрикладныеКлассификаторы

// Открывает форму списка видов номенклатуры.
//
Процедура ОткрытьФормуСпискаВидыНоменклатуры(ВладелецФормы) Экспорт
	
	ИнтеграцияИСУНФКлиент.ОткрытьФормуСпискаВидыНоменклатуры(ВладелецФормы);
	
КонецПроцедуры

// Открывает форму списка номенклатуры.
//
Процедура ОткрытьФормуСпискаНоменклатуры(ВладелецФормы) Экспорт
	
	ИнтеграцияИСУНФКлиент.ОткрытьФормуСпискаНоменклатуры(ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Обработчик специфических сценариев записи объекта в форме (например, после дополнительных ответов пользователя)
//   При переопределении действия:
//     ** Вызвать обработчик ДействиеПослеЗаписи после окончания записи
//     ** Установить признак СтандартнаяОбработка в значение Ложь
//
// Параметры:
//   Форма                - ФормаКлиентскогоПриложения     - источник события записи
//   Объект               - ДанныеФормыСтруктура - записываемый из формы объект
//   ДействиеПослеЗаписи  - ОписаниеОповещения   - действие которое требуется выполнить после записи объекта из формы
//   СтандартнаяОбработка - Булево               - признак стандартной обработки события (запись без блокирующих вызовов)
//
Процедура ВыполнитьЗаписьОбъектаВФорме(Форма, Объект, ДействиеПослеЗаписи, СтандартнаяОбработка) Экспорт
	
	ИнтеграцияИСУНФКлиент.ВыполнитьЗаписьОбъектаВФорме(Форма, Объект, ДействиеПослеЗаписи, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
